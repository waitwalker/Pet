//
//  MTTCollectionViewFlowLayout.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/8/20.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit


/// 瀑布流滚动方向
///
/// - topToBottom: 上到下
/// - leftToRight: 左到右
/// - rightToLeft: 右到左
enum MTTCollectionViewFlowLayoutScrollDirection {
    case topToBottom
    case leftToRight
    case rightToLeft
}

@objc protocol MTTCollectionViewFlowLayoutDelegate:class, UICollectionViewDelegate {
    
    /// 返回每个item的size   
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout 
    ///   - sizeForItemAtIndexPath: indexPath 
    /// - Returns: size 
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    
    
    /// 列数  
    ///
    /// - Parameters:
    ///   - collectionView: 
    ///   - layout: 
    ///   - section: section
    /// - Returns: 列数
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, numberOfColumnsInSection section: Int) -> Int
    
    
    /// 组头高度    
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout 
    ///   - section: section
    /// - Returns: 高度
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, heightForHeaderInSection section:Int) -> CGFloat
    
    
    /// 组尾高度    
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout
    ///   - section: section
    /// - Returns: 高度 
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, heightForFooterInSection section:Int) -> CGFloat
    
    
    /// section之间的间距    
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout
    ///   - section: section 
    /// - Returns: 间距 
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, edgeInsectsForSection section: Int) -> UIEdgeInsets
    
    
    /// 组头间距        
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout
    ///   - section: section 
    /// - Returns: 间距   
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, edgeInsectsForHeaderInSection section: Int) -> UIEdgeInsets
    
    /// 组尾间距        
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout
    ///   - section: section 
    /// - Returns: 间距  
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, edgeInsectsForFooterInSection section: Int) -> UIEdgeInsets
    
    
    /// 最小列间距 如果竖排,指的是左右
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout
    ///   - section: section
    /// - Returns: 间距 
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingInSection section: Int) -> CGFloat
    
    /// 最小行间距 如果竖排,指的是上下行间距
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - layout: layout
    ///   - section: section
    /// - Returns: 间距 
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumColumnSpacingInSection section: Int) -> CGFloat
    
}
// MARK: -
class MTTCollectionViewFlowLayout: UICollectionViewLayout {

    // MARK: - public property 
    /// 列数 默认2
    open var columnCount: Int = 2 {
        didSet{
            if columnCount != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    
    /// 行间距 如果上下滑动,指的是左右列之间的间距
    open var minimumColumnSpacing:CGFloat = 10.0 {
        didSet{
            if minimumColumnSpacing != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    /// 列间距 如果上下滑动,指的是上下行之间的间距
    open var minimumInteritemSpacing:CGFloat = 10.0 {
        didSet{
            if minimumInteritemSpacing != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    
    /// 组头高度
    open var headerHeight:CGFloat = 0.0{
        didSet{
            if headerHeight != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    
    /// 组尾高度
    open var footerHeight:CGFloat = 0.0{
        didSet{
            if footerHeight != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    
    /// 组头间距
    open var headerEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero {
        didSet{
            if headerEdgeInsets != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    /// 组尾间距
    open var footerEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero {
        didSet{
            if footerEdgeInsets != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    
    /// section之间间距
    open var sectionEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero {
        didSet{
            if sectionEdgeInsets != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    
    /// 滚动方向
    open var collectionViewScrollDirection:MTTCollectionViewFlowLayoutScrollDirection = .topToBottom {
        didSet{
            if collectionViewScrollDirection != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    var minimumContentHeight:CGFloat = 0.0
    
    
    // MARK: - private property
    fileprivate weak var delegate:MTTCollectionViewFlowLayoutDelegate! {
        return (self.collectionView?.delegate as! MTTCollectionViewFlowLayoutDelegate)
    }
    
    fileprivate var columnHeights:[[CGFloat]] = []
    fileprivate var sectionItemAttributes:[[UICollectionViewLayoutAttributes]] = []
    fileprivate var allItemAttributes:[UICollectionViewLayoutAttributes] = []
    fileprivate var headerAttributes:[UICollectionViewLayoutAttributes] = []
    fileprivate var footerAttributes:[UICollectionViewLayoutAttributes] = []
    fileprivate var unionRects:[CGRect] = []
    fileprivate let unionSize = 20
    
    fileprivate func columnCount(forSection section:Int) -> Int {
        if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:numberOfColumnsInSection:))) {
            return delegate.collectionView!(self.collectionView!, layout: self, numberOfColumnsInSection: section)
        }
        return columnCount
    }
    
    fileprivate func evaluateSectionInset(forSection section: Int) -> UIEdgeInsets {
        if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:edgeInsectsForSection:))) {
            return delegate.collectionView!(self.collectionView!, layout: self, edgeInsectsForSection: section)
        }
        return sectionEdgeInsets
    }
    
    fileprivate func evaluateMinimumColumnSpacing(forSection section: Int) -> CGFloat {
        if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:minimumColumnSpacingInSection:))) {
            return delegate.collectionView!(self.collectionView!, layout: self, minimumColumnSpacingInSection: section)
        }
        return minimumColumnSpacing
    }
    
    fileprivate func evaluateMinimumInteritemSpacing(forSection section: Int) -> CGFloat {
        if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:minimumInteritemSpacingInSection:))) {
            return delegate.collectionView!(self.collectionView!, layout: self, minimumInteritemSpacingInSection: section)
        }
        return minimumInteritemSpacing
    }
    
    fileprivate func shortestColumn(inSection sectin: Int) -> Int {
        var index = 0
        var shortestHeight = CGFloat(Float.greatestFiniteMagnitude)
        for (idx, height) in self.columnHeights[sectin].enumerated() {
            if height < shortestHeight{
                shortestHeight = height
                index = idx
            }
        }
        return index
    }
    
    fileprivate func longestColumn(inSection section:Int) -> Int {
        var index = 0
        var longestHeight:CGFloat = 0.0
        for (idx, height) in self.columnHeights[section].enumerated() {
            if height > longestHeight {
                longestHeight = height
                index = idx
            }
        }
        return index
    }
    
    fileprivate func nextColumn(forItem item: Int, inSection section: Int) -> Int {
        var index = 0
        let columnCount = self.columnCount(forSection: section)
        switch collectionViewScrollDirection {
        case .topToBottom:
            index = shortestColumn(inSection: section)
        case .leftToRight:
            index = item %  columnCount
        case .rightToLeft:
            index = (columnCount - 1) - (item %  columnCount)
        }
        
        return index
    }
    
    open func itemWidth(inSection section: Int) -> CGFloat {
        let sectionInset = evaluateSectionInset(forSection: section)
        let width = (self.collectionView?.bounds.size.width)! - sectionInset.left - sectionInset.right
        let columnCount = CGFloat(self.columnCount(forSection: section))
        let columnSpacing = evaluateMinimumColumnSpacing(forSection: section)
        return (width - (columnCount - 1.0) * columnSpacing) / columnCount
        
    }
    
    override func prepare() {
        super.prepare()
        
        headerAttributes.removeAll()
        footerAttributes.removeAll()
        unionRects.removeAll()
        columnHeights.removeAll()
        allItemAttributes.removeAll()
        sectionItemAttributes.removeAll()
        
        guard self.collectionView?.numberOfSections != 0 else {
            return
        }
        
        assert(delegate.conforms(to: MTTCollectionViewFlowLayoutDelegate.self), "UICollectionView's delegate should conform to MTTCollectionViewFlowLayoutDelegate protocol")
        assert(columnCount > 0, "column count should greater than 0")
        
        let numberOfSections = (self.collectionView?.numberOfSections)!
        
        for index in 0 ..< numberOfSections {
            let columnCount = self.columnCount(forSection: index)
            let sectionColumnHeight = Array(repeatElement(CGFloat(0), count: columnCount))
            self.columnHeights.append(sectionColumnHeight)
        }
        
        // create attributes
        var top:CGFloat = 0
        
        for section in 0 ..< numberOfSections {
            
            // 1. section
            let interitemSpacing = evaluateMinimumInteritemSpacing(forSection: section)
            let columnSpacing = evaluateMinimumColumnSpacing(forSection: section)
            let sectionInset = evaluateSectionInset(forSection: section)
            
            let width = (self.collectionView?.bounds.size.width)! - sectionInset.left - sectionInset.right
            let columnCount = self.columnCount(forSection: section)
            let itemWidth = (width - (CGFloat(columnCount - 1)) * columnSpacing) / CGFloat(columnCount)
            
            // 2. section header
            var headerH = self.headerHeight
            if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:heightForHeaderInSection:))){
                headerH = delegate.collectionView!(self.collectionView!, layout: self, heightForHeaderInSection: section)
            }
            
            var headerE = self.headerEdgeInsets
            if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:edgeInsectsForHeaderInSection:))) {
                headerE = delegate.collectionView!(self.collectionView!, layout: self, edgeInsectsForHeaderInSection: section)
            }
            
            top += headerE.top
            
            if headerH > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: headerE.left, y: top, width: (self.collectionView?.bounds.size.width)!, height: headerH)
                self.headerAttributes[section] = attributes
                self.allItemAttributes.append(attributes)
                top = attributes.frame.maxY + headerE.bottom
            }
            
            top += sectionInset.top
            for idx in 0 ..< columnCount{
                self.columnHeights[section][idx] = top
            }
            
            // 3. section items
            let itemCount = (self.collectionView?.numberOfItems(inSection: section))!
            var itemAttributes:[UICollectionViewLayoutAttributes] = []
            
            for idx in 0 ..< itemCount {
                let indexPath = IndexPath(item: idx, section: 0)
                let columnIndex = nextColumn(forItem: idx, inSection: section)
                let xOffset = sectionInset.left + (itemWidth + columnSpacing) * CGFloat(columnIndex)
                let yOffset = self.columnHeights[section][columnIndex]
                let itemSize = delegate.collectionView!(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
                var itemHeight:CGFloat = 0.0
                if itemSize.width > 0{
                    itemHeight = itemSize.height * itemWidth / itemSize.width
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                self.allItemAttributes.append(attributes)
                self.columnHeights[section][columnIndex] = attributes.frame.maxY + interitemSpacing
            }
            self.sectionItemAttributes.append(itemAttributes)
            
            // 4. section footer 
            let columnIndex = longestColumn(inSection: section)
            top = self.columnHeights[section][columnIndex] - interitemSpacing + sectionInset.bottom
            
            var footerH = self.footerHeight
            if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:heightForFooterInSection:))) {
                footerH = delegate.collectionView!(self.collectionView!, layout: self, heightForFooterInSection: section)
            }
            
            var footerInset = self.footerEdgeInsets
            if delegate.responds(to: #selector(MTTCollectionViewFlowLayoutDelegate.collectionView(_:layout:edgeInsectsForFooterInSection:))) {
                footerInset = delegate.collectionView!(self.collectionView!, layout: self, edgeInsectsForFooterInSection: section)
            }
            
            top += footerInset.top
            if footerH > 0{
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: footerInset.left, y: top, width: (self.collectionView?.bounds.size.width)! - (footerInset.left + footerInset.right), height: footerH)
                self.footerAttributes[section] = attributes
                self.allItemAttributes.append(attributes)
                top = attributes.frame.maxX + footerInset.bottom
            }
            
            for idx in 0 ..< columnCount{
                self.columnHeights[section][idx] = top
            }
        }
        
        var idx = 0
        let itemCounts = self.allItemAttributes.count
        while idx < itemCounts {
            var unionR = self.allItemAttributes[idx].frame
            let rectEndIndex = min(idx + unionSize, itemCounts)
            for i in idx+1 ..< rectEndIndex{
                unionR = unionR.union(self.allItemAttributes[i].frame)
            }
            idx = rectEndIndex
            self.unionRects.append(unionR)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let numberOfSections = (self.collectionView?.numberOfSections)!
        if numberOfSections == 0 {
            return CGSize.zero
        }
        
        var contentSize = self.collectionView?.bounds.size
        contentSize?.height = (self.columnHeights.last?.first)!
        if (contentSize?.height)! < minimumContentHeight{
            contentSize?.height = self.minimumContentHeight
        }
        return contentSize!
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < self.sectionItemAttributes.count && indexPath.item < self.sectionItemAttributes[indexPath.section].count else {
            return nil
        }
        return self.sectionItemAttributes[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return self.headerAttributes[indexPath.section]
        }
        
        if elementKind == UICollectionView.elementKindSectionFooter {
            return self.footerAttributes[indexPath.section]
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0,end = 0
        
        var attrs:[UICollectionViewLayoutAttributes] = []
        
        for i in 0 ..< self.unionRects.count {
            if rect.intersects(self.unionRects[i]){
                begin = i * unionSize
                break
            }
        }
        
        var idx = self.unionRects.count - 1
        while idx >= 0 {
            if rect.intersects(self.unionRects[idx]){
                end = min((idx + 1) * unionSize, self.allItemAttributes.count)
                break
            }
            
            idx -= 1
        }
        
        for i in begin ..< end {
            let attr = self.allItemAttributes[i]
            if rect.intersects(attr.frame) {
                attrs.append(attr)
            }
        }
        
        return attrs
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = (self.collectionView?.bounds)!
        if newBounds.width != oldBounds.width {
            return true
        }
        return false
    }
    
    
}
