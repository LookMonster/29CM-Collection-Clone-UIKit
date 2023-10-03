//
//  ViewController.swift
//  29CMCollectionView
//
//  Created by 박준하 on 10/2/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var scaleLayout: BannerCollectionViewFlowLayout!
    
    private lazy var datas: [String] = {
       var images = [String]()
        for i in 1...5 {
            images.append("\(i)")
        }
        return images
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        setupCollectionView()
        
    }
    
    func setupLayout() {
        let layout = BannerCollectionViewFlowLayout()
        self.scaleLayout = layout
        layout.isPagingEnabled = true
        layout.transformScale = (300 - 250) / 300.0
        layout.minimumLineSpacing = 10
        layout.minimumAlpha = 0.8

        let itemW: CGFloat = view.bounds.width - 40
        let itemH: CGFloat = view.bounds.height - 300
        layout.itemSize = CGSize(width: itemW, height: itemH)
    }
    
    func setupCollectionView() {
        
        let kScreenW = UIScreen.main.bounds.size.width
        let kScreenH = UIScreen.main.bounds.size.height
        
        let clvH:CGFloat = 300.0
        let clvY = (kScreenH - clvH) * 0.5
        let rect = CGRect(x: 0, y: clvY, width: kScreenW, height: clvH)
        
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: scaleLayout)
        self.collectionView = collectionView
        collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView = collectionView
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(StyleCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StyleCell
        cell.bgImageView.image = UIImage.init(named: datas[indexPath.row])
        
        let cornerRadiusValue : CGFloat = 20.0

        cell.layer.cornerRadius = cornerRadiusValue
        cell.bgImageView.layer.cornerRadius = cornerRadiusValue
        cell.bgImageView.clipsToBounds = true
        
        return cell
    }
}
