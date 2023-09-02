//
//  ImageViewCell.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 31.08.23.
//

import UIKit

protocol ImageViewCellDelegate: AnyObject {
    func didFavoriteImage(at indexPath: IndexPath)
}

final class ImageViewCell: UICollectionViewCell {
    
    weak var delegate: ImageViewCellDelegate?
    var indexPath: IndexPath?
    var imageView: UIImageView!
    
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.addTarget(self, action: #selector(handleFavoriteTap), for: .touchUpInside)
        addSubview(heartButton)

        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            heartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc func handleFavoriteTap() {
        heartButton.isSelected = !heartButton.isSelected
        if let indexPath = indexPath {
            delegate?.didFavoriteImage(at: indexPath)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

