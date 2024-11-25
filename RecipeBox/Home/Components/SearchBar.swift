//
//  SearchBar.swift
//  RecipeBox
//
//  Created by Tatarella on 14.10.24.
//

import UIKit

protocol SearchBarDelegate: AnyObject{
    func handleSearch(keyword: String)
}

class SearchBar: UIView {
    
    weak var delegate: SearchBarDelegate?
    private var debouncer: Debouncer?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray4.withAlphaComponent(0.4)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search recipes"
        textField.borderStyle = .none
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .accent
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        SetupInput()
        debouncer = Debouncer(delay: 1) { [weak self] in
            guard let keyword = self?.textField.text else { return }
            self?.delegate?.handleSearch(keyword: keyword)
        }
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.clearText()
        }), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func SetupInput(){
        self.addSubview(containerView)
        
        containerView.addSubview(textField)
        containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        debouncer?.call()
        closeButton.isHidden = textField.text?.isEmpty ?? true
    }
    
    private func clearText() {
        textField.text = ""
        closeButton.isHidden = true
        delegate?.handleSearch(keyword: "")
    }
}
