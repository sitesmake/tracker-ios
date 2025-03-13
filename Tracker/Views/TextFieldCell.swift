//
//  TextFieldCell.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

protocol TextFieldCellDelegate {
    func didTextChange(text: String?)
}

final class TextFieldCell: UITableViewCell {
    
    var delegate: TextFieldCellDelegate?
    
    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .always
        textField.delegate = self
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubviews()
        constraintSubviews()
        backgroundColor = .ypBackground
        selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(textField)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didTextChange(text: textField.text)
    }
}
