// Copyright 2017 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#import <AVFoundation/AVFoundation.h>
#include <vector>

#include "tensorflow/contrib/lite/kernels/register.h"
#include "tensorflow/contrib/lite/model.h"


#import "MTTPetRecogniseHandler.h"
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>

#include <sys/time.h>
#include <fstream>
#include <iostream>
#include <queue>

#include "tensorflow/contrib/lite/kernels/register.h"
#include "tensorflow/contrib/lite/model.h"
#include "tensorflow/contrib/lite/string_util.h"
#include "tensorflow/contrib/lite/op_resolver.h"

#define LOG(x) std::cerr

namespace {
// If you have your own model, modify this to the file name, and make sure
// you've added the file to your app resources too.
NSString* model_file_name = @"trained_data";
NSString* model_file_type = @"tflite";
// If you have your own model, point this to the labels file.
NSString* labels_file_name = @"objects";
NSString* labels_file_type = @"txt";

// These dimensions need to match those the model was trained with.
const int wanted_input_width = 224;
const int wanted_input_height = 224;
const int wanted_input_channels = 3;
const float input_mean = 127.5f;
const float input_std = 127.5f;
const std::string input_layer_name = "input";
const std::string output_layer_name = "softmax1";

#pragma mark 获取文件
NSString* FilePathForResourceName(NSString* name, NSString* extension) {
    NSString* file_path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    if (file_path == NULL) {
        NSLog(@"Couldn't find: %@. in bundle:%@", name,extension);
    }
    return file_path;
}

#pragma mark 加载文件
void LoadLabels(NSString* file_name,
                NSString* file_type,
                std::vector<std::string>* label_strings)
    {
        NSString* labels_path = FilePathForResourceName(file_name, file_type);
        if (!labels_path) {
            NSLog(@"Failed to find model proto at:%@ %@",file_name, file_type);
        }
        std::ifstream t;
        t.open([labels_path UTF8String]);
        std::string line;
        while (t) {
            std::getline(t, line);
            label_strings->push_back(line);
        }
        t.close();
    }

// Returns the top N confidence values over threshold in the provided vector,
// sorted by confidence in descending order.
void GetTopN(const float* prediction,
             const int prediction_size,
             const int num_results,
             const float threshold,
             std::vector<std::pair<float, int> >* top_results) {
  // Will contain top N results in ascending order.
  std::priority_queue<std::pair<float, int>, std::vector<std::pair<float, int> >,
                      std::greater<std::pair<float, int> > >
      top_result_pq;

  const long count = prediction_size;
  for (int i = 0; i < count; ++i) {
    const float value = prediction[i];
    // Only add it if it beats the threshold and has a chance at being in
    // the top N.
    if (value < threshold) {
      continue;
    }

    top_result_pq.push(std::pair<float, int>(value, i));

    // If at capacity, kick the smallest value out.
    if (top_result_pq.size() > num_results) {
      top_result_pq.pop();
    }
  }

  // Copy to output vector and reverse into descending order.
  while (!top_result_pq.empty()) {
    top_results->push_back(top_result_pq.top());
    top_result_pq.pop();
  }
  std::reverse(top_results->begin(), top_results->end());
}

// Preprocess the input image and feed the TFLite interpreter buffer for a float model.
void ProcessInputWithFloatModel(
    uint8_t* input, float* buffer, int image_width, int image_height, int image_channels) {
  for (int y = 0; y < wanted_input_height; ++y) {
    float* out_row = buffer + (y * wanted_input_width * wanted_input_channels);
    for (int x = 0; x < wanted_input_width; ++x) {
      const int in_x = (y * image_width) / wanted_input_width;
      const int in_y = (x * image_height) / wanted_input_height;
      uint8_t* input_pixel =
          input + (in_y * image_width * image_channels) + (in_x * image_channels);
      float* out_pixel = out_row + (x * wanted_input_channels);
      for (int c = 0; c < wanted_input_channels; ++c) {
        out_pixel[c] = (input_pixel[c] - input_mean) / input_std;
      }
    }
  }
}

// Preprocess the input image and feed the TFLite interpreter buffer for a quantized model.
void ProcessInputWithQuantizedModel(
    uint8_t* input, uint8_t* output, int image_width, int image_height, int image_channels) {
  for (int y = 0; y < wanted_input_height; ++y) {
    uint8_t* out_row = output + (y * wanted_input_width * wanted_input_channels);
    for (int x = 0; x < wanted_input_width; ++x) {
      const int in_x = (y * image_width) / wanted_input_width;
      const int in_y = (x * image_height) / wanted_input_height;
      uint8_t* in_pixel = input + (in_y * image_width * image_channels) + (in_x * image_channels);
      uint8_t* out_pixel = out_row + (x * wanted_input_channels);
      for (int c = 0; c < wanted_input_channels; ++c) {
        out_pixel[c] = in_pixel[c];
      }
    }
  }
}
}  // namespace

@interface MTTPetRecogniseHandler(){
    
    std::vector<std::string> labels;
    std::unique_ptr<tflite::FlatBufferModel> model;
    tflite::ops::builtin::BuiltinOpResolver resolver;
    std::unique_ptr<tflite::Interpreter> interpreter;
    
    double total_latency;
    int total_count;
}


@end

@implementation MTTPetRecogniseHandler

- (instancetype)init {
    if (self = [super init]) {
        NSString* graph_path = FilePathForResourceName(model_file_name, model_file_type);
        model = tflite::FlatBufferModel::BuildFromFile([graph_path UTF8String]);
        if (!model) {
            LOG(FATAL) << "Failed to mmap model " << graph_path;
        }
        LOG(INFO) << "Loaded model " << graph_path;
        model->error_reporter();
        LOG(INFO) << "resolved reporter";
        
        tflite::ops::builtin::BuiltinOpResolver resolver;
        LoadLabels(labels_file_name, labels_file_type, &labels);
        
        tflite::InterpreterBuilder(*model, resolver)(&interpreter);
        // Explicitly resize the input tensor.
        {
            int input = interpreter->inputs()[0];
            std::vector<int> sizes = {1, 224, 224, 3};
            interpreter->ResizeInputTensor(input, sizes);
        }
        if (!interpreter) {
            LOG(FATAL) << "Failed to construct interpreter";
        }
        if (interpreter->AllocateTensors() != kTfLiteOk) {
            LOG(FATAL) << "Failed to allocate tensors!";
        }
    }
    return self;
}


- (void)recogniseImageWithCVPixelBufferRef:(CVPixelBufferRef)pixelBuffer delegate:(id<MTTPetRecogniseHandlerDelegate>)delegate{
    assert(pixelBuffer != NULL);
    
    OSType sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
           sourcePixelFormat == kCVPixelFormatType_32BGRA);
    
    const int sourceRowBytes = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    const int image_width = (int)CVPixelBufferGetWidth(pixelBuffer);
    const int fullHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    CVPixelBufferLockFlags unlockFlags = kNilOptions;
    CVPixelBufferLockBaseAddress(pixelBuffer, unlockFlags);
    
    unsigned char* sourceBaseAddr = (unsigned char*)(CVPixelBufferGetBaseAddress(pixelBuffer));
    int image_height;
    unsigned char* sourceStartAddr;
    if (fullHeight <= image_width) {
        image_height = fullHeight;
        sourceStartAddr = sourceBaseAddr;
    } else {
        image_height = image_width;
        const int marginY = ((fullHeight - image_width) / 2);
        sourceStartAddr = (sourceBaseAddr + (marginY * sourceRowBytes));
    }
    const int image_channels = 4;
    assert(image_channels >= wanted_input_channels);
    uint8_t* in = sourceStartAddr;
    
    int input = interpreter->inputs()[0];
    TfLiteTensor *input_tensor = interpreter->tensor(input);
    
    bool is_quantized;
    switch (input_tensor->type) {
        case kTfLiteFloat32:
            is_quantized = false;
            break;
        case kTfLiteUInt8:
            is_quantized = true;
            break;
        default:
            NSLog(@"Input data type is not supported by this demo app.");
            return;
    }
    
    if (is_quantized) {
        uint8_t* out = interpreter->typed_tensor<uint8_t>(input);
        ProcessInputWithQuantizedModel(in, out, image_width, image_height, image_channels);
    } else {
        float* out = interpreter->typed_tensor<float>(input);
        ProcessInputWithFloatModel(in, out, image_width, image_height, image_channels);
    }
    
    double start = [[NSDate new] timeIntervalSince1970];
    if (interpreter->Invoke() != kTfLiteOk) {
        LOG(FATAL) << "Failed to invoke!";
    }
    double end = [[NSDate new] timeIntervalSince1970];
    total_latency += (end - start);
    total_count += 1;
    NSLog(@"Time: %.4lf, avg: %.4lf, count: %d", end - start, total_latency / total_count,
          total_count);
    
    const int output_size = 1000;
    const int kNumResults = 5;
    const float kThreshold = 0.1f;
    
    std::vector<std::pair<float, int> > top_results;
    
    if (is_quantized) {
        uint8_t* quantized_output = interpreter->typed_output_tensor<uint8_t>(0);
        int32_t zero_point = input_tensor->params.zero_point;
        float scale = input_tensor->params.scale;
        float output[output_size];
        for (int i = 0; i < output_size; ++i) {
            output[i] = (quantized_output[i] - zero_point) * scale;
        }
        GetTopN(output, output_size, kNumResults, kThreshold, &top_results);
    } else {
        float* output = interpreter->typed_output_tensor<float>(0);
        GetTopN(output, output_size, kNumResults, kThreshold, &top_results);
    }
    
    NSMutableDictionary* newValues = [NSMutableDictionary dictionary];
    for (const auto& result : top_results) {
        const float confidence = result.first;
        const int index = result.second;
        NSString* labelObject = [NSString stringWithUTF8String:labels[index].c_str()];
        NSNumber* valueObject = [NSNumber numberWithFloat:confidence];
        [newValues setObject:valueObject forKey:labelObject];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if ([delegate respondsToSelector:@selector(dRecognisedWithValue:)]) {
            [delegate dRecognisedWithValue:newValues];
        }
    });
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, unlockFlags);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (UIImage *) originalImge
{
    CGImageRef image = originalImge.CGImage;
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
                              };
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end
