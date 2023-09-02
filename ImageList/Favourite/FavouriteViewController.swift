//
//  FavouriteViewController.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 01.09.23.
//

import Foundation
import UIKit
import Kingfisher

//final class FavouriteViewController: UIViewController {
//
//    var images: [Image] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//    }
//}

final class FavouriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var favourite: [Image] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2 - (layout.minimumInteritemSpacing * 1 / 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Setup collectionView
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - UICollectionView DataSource & Delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourite.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! ImageViewCell
        let image = favourite[indexPath.item]
        let url = image.url
        let size = CGSize(width: 70, height: 70)
        let processor = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        
        // Set up cell's delegate and indexPath for heart button
        cell.delegate = self
        cell.indexPath = indexPath
        cell.heartButton.isSelected = true // As they are already favorites
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // You can handle cell tap here if needed, perhaps to show a larger view of the image or additional details
    }
}

extension FavouriteViewController: ImageViewCellDelegate {
    func didFavoriteImage(at indexPath: IndexPath) {
        favourite.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

