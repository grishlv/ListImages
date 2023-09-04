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
    
    var delegate: ImageViewCellDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var indexPath: IndexPath?
    
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(imageView)
        addSubview(heartButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            heartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            heartButton.widthAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        heartButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    @objc func favouriteButtonTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.didFavoriteImage(at: indexPath)
    }
}
