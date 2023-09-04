//
//  MainViewModel.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 30.08.23.
//

import Foundation
import Kingfisher

final class MainPresenter {
    
    var images: [Image] = []
    var favourites: [Favourite] = []
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchImages(completion: @escaping() -> Void) {
        networkService.fetchImages { [weak self] images, error in
            if let images = images {
                self?.images = images
            }
            completion()
        }
    }
    
    //MARK: - optimized loading
    func prefetchImagesForVisibleCells(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { images[$0.item].url }
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
    
    func filterImages(by filter: String) {
        switch filter {
        case "id":
            images.sort(by: { $0.id < $1.id })
        case "title":
            images.sort(by: { $0.title < $1.title })
        default:
            break
        }
    }
    
    func toggleFavorite(forImageAt index: Int) {
        let image = images[index]
        if let existingIndex = favourites.firstIndex(where: { $0.image.id == image.id }) {
            favourites.remove(at: existingIndex)
            
        } else {
            favourites.append(Favourite(image: image, isFavourite: true))
        }
    }
}
