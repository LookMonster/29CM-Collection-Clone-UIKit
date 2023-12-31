//
//  29BannerCollectionViewFlowLayout.swift
//  29CMCollectionView
//
//  Created by 박준하 on 10/3/23.
//

import UIKit

// 배너 형식의 컬렉션 뷰 레이아웃 클래스
public class BannerCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // 페이지 효과
    open var isPagingEnabled: Bool = true
    
    // 셀 크기를 조절
    open var transformScale: CGFloat = 1
    
    // 셀의 최소 투명도
    open var minimumAlpha: CGFloat = 1
    
    private var isFirstLayout: Bool = true
    
    override open func prepare() {
        super.prepare()
        if isFirstLayout {
            resetLayout()
            isFirstLayout = false
        }
    }
    
    private func resetLayout() {
        if minimumAlpha > 1 || minimumAlpha < 0 {
            minimumAlpha = 1
        }
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        
        if let collectionView = self.collectionView {
            let clvW = collectionView.frame.size.width
            
            let itemWidth: CGFloat = clvW * 0.8
            itemSize = CGSize(width: itemWidth, height: itemSize.height)
            
            let insetLeftRight = (clvW - itemWidth) * 0.5
            var inset = collectionView.contentInset
            inset.left = insetLeftRight
            inset.right = insetLeftRight
            collectionView.contentInset = inset
            
             if isPagingEnabled {
                 collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
             }
             
             let offsetW = itemSize.width * transformScale * 0.5
             let newSpacing = minimumLineSpacing - offsetW

             minimumLineSpacing -= newSpacing
         }
    }
    
    // 현재 화면에 보이는 엘리먼트의 레이아웃 속성을 반환하는 메서드
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect),
            let collectionView = self.collectionView {
            
            let visibleRect = CGRect(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y, width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            
            guard let copyAttributes = NSArray(array: attributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
            
            let newAttributes = copyAttributes.map { (attribute) -> UICollectionViewLayoutAttributes in
                attribute.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
                
                if visibleRect.intersects(attribute.frame) {
                    
                    let contentOffsetX = collectionView.contentOffset.x
                    let collectionViewCenterX = collectionView.bounds.size.width * 0.5
                    
                    let centerX = attribute.center.x
                    let distance = abs(centerX - contentOffsetX - collectionViewCenterX)
                    
                    let totalDistance = itemSize.width + minimumLineSpacing
                    
                    let ratio: CGFloat = transformScale
                    
                    let newW = itemSize.width - itemSize.width * ratio
                    let offsetW = abs((totalDistance - distance) / totalDistance * (newW - itemSize.width))
                    
                    let scale = (newW + offsetW) / itemSize.width
                    
                    // 투명도 및 스케일 조절
                    attribute.alpha = minimumAlpha + ((1 - minimumAlpha) / totalDistance) * (totalDistance - distance)
                    attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
                    attribute.zIndex = Int(scale * 10)
                }
                
                return attribute
            }
            
            return newAttributes
        }
        return nil
    }
    
    // 스크롤 시 레이아웃 업데이트가 필요한지 여부를 반환하는 메서드
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // 스크롤 시 목표 컨텐츠 오프셋을 계산하는 메서드
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if isPagingEnabled == false {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        if let collectionView = self.collectionView {
            
            let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            
            let centerX = proposedContentOffset.x + collectionView.frame.size.width * 0.5;
            
            if let attributes = self.layoutAttributesForElements(in: lastRect) {
                
                var adjustOffsetX = CGFloat(MAXFLOAT)
                
                for att in attributes {
                    let offsetX = abs(att.center.x - centerX)
                    if offsetX < abs(adjustOffsetX) {
                        adjustOffsetX = att.center.x - centerX
                    }
                }
                
                var newProposedContentOffsetX = proposedContentOffset.x + adjustOffsetX
                
                let maxOffsetX = collectionView.contentSize.width - collectionView.frame.size.width + collectionView.contentInset.left
                
                if newProposedContentOffsetX > maxOffsetX {
                    newProposedContentOffsetX = maxOffsetX
                }
                
                return CGPoint(x: newProposedContentOffsetX, y: proposedContentOffset.y)
            }
        }
        
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}
