//
//  RecipeCollectionViewCell.swift
//  RecipeBox
//
//  Created by Tatarella on 12.10.24.
//

import UIKit
import SDWebImage

class RecipeCollectionViewCell: UICollectionViewCell {
    
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
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.layer.zPosition = 1
        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        return imageView
    }()
    
    private let textView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray4.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.zPosition = 2
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.5"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Classic Greek Salad"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
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
        
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(loader)
        contentView.addSubview(ratingView)
        contentView.addSubview(textView)
        
        ratingView.addSubview(ratingLabel)
        textView.addSubview(titleLabel)
        textView.addSubview(timeTextLabel)
        textView.addSubview(timeLabel)
        
        // Disable Autoresizing Mask Translation
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // ImageView at the top
            imageView.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            //loader
            loader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            
            // Rating View at top-right of image
            ratingView.topAnchor
                .constraint(equalTo: imageView.topAnchor, constant: -5),
            ratingView.trailingAnchor
                .constraint(equalTo: imageView.trailingAnchor, constant: 5),
            ratingView.widthAnchor.constraint(equalToConstant: 40),
            ratingView.heightAnchor.constraint(equalToConstant: 24),
            
            // textview below image
            
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 70),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Rating Label inside the rating view
            ratingLabel.centerXAnchor
                .constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor
                .constraint(equalTo: ratingView.centerYAnchor),
            
            // Title Label below the image
            titleLabel.topAnchor
                .constraint(equalTo: textView.topAnchor, constant: 60),
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
