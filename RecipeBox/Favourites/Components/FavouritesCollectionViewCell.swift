//
//  FavouritesCollectionViewCell.swift
//  RecipeBox
//
//  Created by Tatarella on 09.11.24.
//

import UIKit

class FavouritesCollectionViewCell: UICollectionViewCell {
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.color = .accent
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.layer.zPosition = 2
        return loader
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.zPosition = 1
        return imageView
    }()
    
    private let textView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let timeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "15 Mins"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the UI elements and constraints
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .gray.withAlphaComponent(0.1)
        
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(loader)
        contentView.addSubview(textView)
        
        textView.addSubview(titleLabel)
        textView.addSubview(timeTextLabel)
        textView.addSubview(timeLabel)
        
        // Disable Autoresizing Mask Translation
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // ImageView at the top
            imageView.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            //loader
            loader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            
            // textview below image
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            
            // Title Label below the image
            titleLabel.topAnchor
                .constraint(equalTo: textView.topAnchor, constant: 20),
            titleLabel.leadingAnchor
                .constraint(equalTo: textView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor
                .constraint(equalTo: textView.trailingAnchor, constant: -10),
            
            // Time Label below the title
            timeTextLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -20),
            timeTextLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
            // Time Label below the timeTextLabel
            timeLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10),
            timeLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
        ])
    }
    
    // Configure the cell with data
    func configure(with recipe: RecipeModel) {
        titleLabel.text = recipe.name
        timeLabel.text = "\(recipe.time) Mins"
        let image = recipe.imageURL.isEmpty ? "NoImage" : recipe.imageURL
        
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
