//
//  DynamicInputStack.swift
//  RecipeBox
//
//  Created by Tatarella on 25.10.24.
//

import UIKit

class DynamicInputStack: UIView {
    
    private var initialInputField: FormInput
    
    private let stackView = UIStackView()
    private var inputPlaceholder: String
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(inputPlaceholder: String, buttonTitle: String) {
        addButton.setTitle(buttonTitle, for: .normal)
        self.inputPlaceholder = inputPlaceholder
        self.Label.text = inputPlaceholder
        self.initialInputField = FormInput(placeholder: inputPlaceholder)
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(Label)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        addSubview(addButton)
        addButton.addAction(UIAction(handler: {[weak self] _ in self?.addInputField() }), for: .touchUpInside)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            Label.topAnchor.constraint(equalTo: topAnchor),
            stackView.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.addArrangedSubview(initialInputField)
        
    }
    
    private func addInputField(removable: Bool = true) {
        let inputField = FormInput(placeholder: inputPlaceholder, removable: removable)
        inputField.onRemove = { [weak self, weak inputField] in
            guard let self = self, let input = inputField else { return }
            self.stackView.removeArrangedSubview(input)
            input.removeFromSuperview()
        }
        stackView.addArrangedSubview(inputField)
    }
    
    func getInputs() -> [String] {
        return stackView.arrangedSubviews.compactMap { ($0 as? FormInput)?.getText() }.filter { !$0.isEmpty }
    }
    
    func configureWithInputs(_ inputs: [String]) {
        clearAllInputs()
        for (index, input) in inputs.enumerated() {
            let isRemovable = index > 0
            let inputField = FormInput(placeholder: inputPlaceholder, removable: isRemovable)
            inputField.setText(input)
            
            if isRemovable {
                inputField.onRemove = { [weak self, weak inputField] in
                    guard let self = self, let input = inputField else { return }
                    self.stackView.removeArrangedSubview(input)
                    input.removeFromSuperview()
                }
            }
            
            stackView.addArrangedSubview(inputField)
        }
        
    }
    
    
    func clearAllInputs() {
        for view in stackView.arrangedSubviews {
            if let inputField = view as? FormInput, inputField != initialInputField {
                stackView.removeArrangedSubview(inputField)
                inputField.removeFromSuperview()
            }
        }
        
        initialInputField.clearText()
    }
}
