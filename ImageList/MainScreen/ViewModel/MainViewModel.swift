//
//  MainViewModel.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 30.08.23.
//

import Foundation

final class MainViewModel {
    
    var images: [Image] = []
    var favourite: [Image] = []
    var networkService = NetworkService()
    
    public func fetchImages(completion: @escaping() -> Void) {
        networkService.fetchImages { [weak self] images, error in
            if let images = images {
                self?.images = images
            }
            completion()
        }
    }
    
    public func filterImages(by filter: String) {
        switch filter {
        case "id":
            images.sort(by: { $0.id < $1.id })
        case "title":
            images.sort(by: { $0.title < $1.title })
        default:
            break
        }
    }
}

