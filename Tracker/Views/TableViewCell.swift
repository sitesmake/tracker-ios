//
//  TableViewCell.swift
//  Tracker
//
//  Created by alexander on 11.03.2025.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = .ypBackground
        textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .ypBlack
        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.textColor = .ypGray
        selectionStyle = .default
    }
}
