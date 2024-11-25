//
//  RecipeCollectionViewCell.swift
//  RecipeBox
//
//  Created by Tatarella on 12.10.24.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.layer.zPosition = 1
        return imageView
    }()
    
    let textView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray4.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    
    let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.zPosition = 2
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.5"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Classic Greek Salad"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let timeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "15 Mins"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "bookmark",
            withConfiguration: UIImage.SymbolConfiguration(weight: .regular)
        )
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.systemGreen
        return button
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
        contentView.addSubview(ratingView)
        contentView.addSubview(textView)
        
        ratingView.addSubview(ratingLabel)
        textView.addSubview(titleLabel)
        textView.addSubview(timeTextLabel)
        textView.addSubview(timeLabel)
        textView.addSubview(bookmarkButton)
        
        // Disable Autoresizing Mask Translation
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // ImageView at the top
            imageView.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
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
            
            // Bookmark button at the bottom-right
            bookmarkButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10),
            bookmarkButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -10),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    // Configure the cell with data
    func configure(with recipe: Recipe) {
        imageView.image = UIImage(named: recipe.imageName)
        titleLabel.text = recipe.title
        timeLabel.text = "\(recipe.time) Mins"
        ratingLabel.text = "\(recipe.rating)"
    }
}


struct Recipe {
    let title: String
    let time: Int
    let rating: Double
    let imageName: String
}
