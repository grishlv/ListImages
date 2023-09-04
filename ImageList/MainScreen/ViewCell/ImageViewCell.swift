//
//  ImageViewCell.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 31.08.23.
//

import UIKit

final class ImageViewCell: UICollectionViewCell {
    
    var delegate: ImageViewCellDelegate?
    var imageView: UIImageView!
    var indexPath: IndexPath?

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
        heartButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        addSubview(heartButton)

        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            heartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            heartButton.widthAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func favouriteButtonTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.didFavoriteImage(at: indexPath)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ImageViewCellDelegate: AnyObject {
    func didFavoriteImage(at indexPath: IndexPath)
}
