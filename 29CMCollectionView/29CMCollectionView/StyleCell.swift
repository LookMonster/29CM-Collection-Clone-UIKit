//
//  StyleCell.swift
//  29CMCollectionView
//
//  Created by 박준하 on 10/2/23.
//

import Foundation
import UIKit
import SnapKit

class StyleCell: UICollectionViewCell {
    
    var bgImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgImageView = UIImageView()
        contentView.addSubview(bgImageView)
        self.bgImageView = bgImageView
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

