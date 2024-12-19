//
//  FilterView.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation
import UIKit

class FilterView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum FilterViewOptions : String, CaseIterable {
        case active = "Active Coins"
        case inactive = "Inactive Coins"
        case onlyTokens = "Only Tokens"
        case onlyCoins = "Only Coins"
        case newCoins = "New Coins"
    }
    
    private var collectionView: UICollectionView!
    private var data: [String] = FilterViewOptions.allCases.map({ $0.rawValue })
    private var selectedItems: Set<Int> = []
    
    var onSelectionChanged: ((Set<FilterViewOptions>) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray.withAlphaComponent(0.1)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
        
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Public Methods
    func setData(_ newData: [String]) {
        data = newData
        collectionView.reloadData()
    }
    
    func getSelectedItems() -> [FilterViewOptions] {
        let items = selectedItems.compactMap({ FilterViewOptions.init(rawValue: data[$0]) })
        return items
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        
        let isSelected = selectedItems.contains(indexPath.item)
        cell.configure(with: data[indexPath.item], isSelected: isSelected)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedItems.contains(indexPath.item) {
            selectedItems.remove(indexPath.item)
        } else {
            selectedItems.insert(indexPath.item)
        }
        collectionView.reloadItems(at: [indexPath])
        let items = selectedItems.compactMap({ FilterViewOptions.init(rawValue: data[$0]) })
        onSelectionChanged?(Set(items))
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = data[indexPath.item]
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let maxWidth = collectionView.frame.width - 20
        
        let labelWidth = text.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                                           options: .usesLineFragmentOrigin,
                                           attributes: [.font: font],
                                           context: nil).width
        var baseWidth = max(labelWidth + 20, 60)
        let height: CGFloat = 40
        baseWidth = selectedItems.contains(indexPath.item) ? baseWidth + 20 : baseWidth
        return CGSize(width: baseWidth, height: height)
    }
}

class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    
    private let titleLabel = UILabel()
    private let checkmarkView = UIImageView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = .white
        checkmarkView.isHidden = true

        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center

        stackView.addArrangedSubview(checkmarkView)
        stackView.addArrangedSubview(titleLabel)

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkView.isHidden = !isSelected
        contentView.backgroundColor = isSelected ? UIColor(red: 89.0 / 255.0, green: 13.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0) : .lightGray
    }
}
