//
//  ProfileCollectionViewCell.swift
//  RecipeBox
//
//  Created by Tatarella on 03.11.24.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
           let overlay = UIView()
           overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
           overlay.layer.cornerRadius = 10
           overlay.translatesAutoresizingMaskIntoConstraints = false
           return overlay
       }()
    
    var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.color = .accent
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.layer.zPosition = 2
        return loader
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(loader)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(image: String, title: String) {
        titleLabel.text = title
        let image = image.isEmpty ? "NoImage" : image
        if image != "NoImage",let imageURL = URL(string: image) {
            loader.startAnimating()
            self.imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) { [weak self] downloadedImage, error, _, _ in
                self?.loader.stopAnimating()
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                self?.imageView.image = UIImage(named: "NoImage")
            } else {
                self?.imageView.image = downloadedImage
            }
        }
        } else {
            self.imageView.image = UIImage(named: image)
        }
    }
}
