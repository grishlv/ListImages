//
//  ImageCardViewController.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 31.08.23.
//

import Foundation
import UIKit

final class ImageDetailViewController: UIViewController {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupImageView()
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    //MARK: - setup image view
    private func setupImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
