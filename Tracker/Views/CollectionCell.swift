//
//  CollectionCell.swift
//  Tracker
//
//  Created by alexander on 26.03.2025.
//

import UIKit

final class CollectionCell: UITableViewCell {
    enum CollectionCellType {
        case icon(items: [String])
        case color(items: [UIColor?])
    }
    
    enum Constants {
        static let colorCellIdentifier = "ColorsCollectionViewCell"
        static let iconCellIdentifier = "IconsCollectionViewCell"
        static let headerIdentifier = "IconsCellHeader"
        static let contentInsets: CGFloat = 16
        static let spacing: CGFloat = 0
        static let cellCountInline = 6
        static let headerHeight: CGFloat = 30
        static let topInsetsSection: CGFloat = 16
    }
    
    weak var delegate: CollectionCellDelegate?
    
    var type: CollectionCellType = .icon(items: []) {
        didSet {
            iconsCollectionView.reloadData()
            updateSize()
        }
    }
    
    private var cellHeight: NSLayoutConstraint?
    
    private var cellSize: CGFloat {
        let size = ((UIScreen.main.bounds.width - Constants.contentInsets * 2) / CGFloat(Constants.cellCountInline)).rounded(.down)
        return size - CGFloat(Constants.cellCountInline)
    }
    
    private lazy var iconsCollectionView: ResizableCollectionView = {
        let collectionView = ResizableCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.register(IconsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.iconCellIdentifier)
        collectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.colorCellIdentifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerIdentifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSize()
    }
    
    private func updateSize() {
        iconsCollectionView.layoutIfNeeded()
    }
    
    private func setupSubviews() {
        addSubviews()
        constraintSubviews()
        backgroundColor = .ypWhite
        selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(iconsCollectionView)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            iconsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

extension CollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .icon(let items):
            return items.count
        case .color(let items):
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch type {
            
        case .icon(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.iconCellIdentifier, for: indexPath) as? IconsCollectionViewCell else { return UICollectionViewCell() }
            cell.icon = items[indexPath.row]
            return cell
        case .color(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.colorCellIdentifier, for: indexPath) as? ColorsCollectionViewCell else { return UICollectionViewCell() }
            cell.color = items[indexPath.row]
            return cell
        }
    }
}

extension CollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerIdentifier, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        
        switch type {
            
        case .icon:
            view.title.text = "Emoji"
        case .color:
            view.title.text = "Цвет"
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch type {
        case .icon:
            guard let cell = collectionView.cellForItem(at: indexPath) as? IconsCollectionViewCell else { return }
            delegate?.didIconSet(icon: cell.icon)
        case .color:
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell else { return }
            delegate?.didColorSet(color: cell.color)
        }
    }
}

extension CollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: Constants.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: Constants.topInsetsSection, left: 0, bottom: 0, right: 0)
    }
}
