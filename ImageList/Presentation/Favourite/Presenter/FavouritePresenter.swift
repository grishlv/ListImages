//
//  FavouriteViewModel.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 02.09.23.
//

import Foundation
import UIKit

final class FavouritePresenter {
    
    weak var view: FavouriteView?
    var favourites: [Favourite] = []
    
    init(view: FavouriteView? = nil, favourites: [Favourite] = []) {
        self.view = view
        self.favourites = favourites
    }
    
    func loadFavourites() {
        view?.reloadData()
    }
    
    func removeFavouriteById(_ id: Int) {
        if let index = favourites.firstIndex(where: { $0.image.id == id }) {
            favourites.remove(at: index)
        }
    }
}

protocol FavouriteView: AnyObject {
    func reloadData()
}

protocol FavouriteControllerDelegate: AnyObject {
    func didUpdateFavorites(updatedFavorites: [Favourite])
}
