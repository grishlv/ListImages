//
//  ViewController.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 30.08.23.
//

import UIKit
import Kingfisher

final class MainViewController: UIViewController {
    
    private let presenter: MainPresenter
    private let pickerComponents = ["id", "title"]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2 - (layout.minimumInteritemSpacing * 1 / 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
             
        setupView()
        setupCollectionView()
        presenter.fetchImages { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.prefetchImages()
            }
        }
    }
    
    private func prefetchImages() {
        presenter.prefetchImagesForVisibleCells(indexPaths: collectionView.indexPathsForVisibleItems)
    }
    
    private func setupView() {
        view.backgroundColor = .black
        navigationItem.title = "Image list"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(filterButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(favouriteButtonTapped))
    }
    
    //MARK: - setup collection view
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc func filterButtonTapped() {
        let alertController = UIAlertController(title: "Filter", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        pickerView.frame = CGRect(x: 0, y: 20, width: alertController.view.bounds.width - 20, height: 150)
        alertController.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "Done", style: .default) { [unowned self] _ in
            self.presenter.filterImages(by: self.pickerComponents[self.pickerView.selectedRow(inComponent: 0)])
            self.collectionView.reloadData()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc func favouriteButtonTapped() {
        let favouritePresenter = FavouritePresenter(favourites: presenter.favourites)
        let favouriteVC = FavouriteViewController(presenter: favouritePresenter)
        favouriteVC.delegate = self
        navigationController?.pushViewController(favouriteVC, animated: true)
    }
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageViewCell
        let image = presenter.images[indexPath.item]
        let url = image.url
        let size = CGSize(width: 70, height: 70)
        let processor = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.heartButton.isSelected = presenter.favourites.contains { $0.image.id == image.id }
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageModel = presenter.images[indexPath.row]
        let imageUrl = imageModel.url
        
        KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    let detailViewController = ImageDetailViewController()
                    detailViewController.setImage(image: value.image)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        prefetchImages()
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerComponents[row]
    }
}

extension MainViewController: ImageViewCellDelegate {
    func didFavoriteImage(at indexPath: IndexPath) {
        presenter.toggleFavorite(forImageAt: indexPath.row)
        collectionView.reloadItems(at: [indexPath])
    }
}

extension MainViewController: FavouriteControllerDelegate {
    func didUpdateFavorites(updatedFavorites: [Favourite]) {
        presenter.favourites = updatedFavorites
        collectionView.reloadData()
    }
}
