//
//  FavouriteViewController.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 01.09.23.
//

import UIKit
import Kingfisher

final class FavouriteViewController: UIViewController {
    
    var images: [Image] = []
    var presenter: FavouritePresenter!
    weak var delegate: FavouriteControllerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2 - (layout.minimumInteritemSpacing * 1 / 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        presenter.loadFavourites()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    init(presenter: FavouritePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageViewCell
        let imageModel = presenter.favourites[indexPath.row].image
        
        let url = imageModel.url
        let size = CGSize(width: 70, height: 70)
        let processor = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        cell.heartButton.isSelected = true
        return cell
    }
}

extension FavouriteViewController: FavouriteView {
    func reloadData() {
        collectionView.reloadData()
    }
}

extension FavouriteViewController: ImageViewCellDelegate {
    func didFavoriteImage(at indexPath: IndexPath) {
        if indexPath.row < presenter.favourites.count {
            let removedFavourite = presenter.favourites[indexPath.row]
            presenter.removeFavouriteById(removedFavourite.image.id)
            collectionView.reloadData()
            delegate?.didUpdateFavorites(updatedFavorites: presenter.favourites)
        }
    }
}
