//
//  CoinTableViewCell.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    static let identifier = "CoinTableViewCell"
    
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let coinImageView = UIImageView()
    private let newTagLabel = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .gray
        
        symbolLabel.font = UIFont.boldSystemFont(ofSize: 14)
        symbolLabel.textColor = .black
        
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        
        newTagLabel.image = UIImage.init(named: "new")
        newTagLabel.layer.cornerRadius = 5
        newTagLabel.clipsToBounds = true
        newTagLabel.isHidden = true
        
        // Add Subviews
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(coinImageView)
        contentView.addSubview(newTagLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        newTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            coinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            
            newTagLabel.topAnchor.constraint(equalTo: coinImageView.topAnchor, constant: -5),
            newTagLabel.trailingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 5),
            newTagLabel.widthAnchor.constraint(equalToConstant: 40),
            newTagLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    // MARK: - Configuration
    func configure(with coin: Coin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        if coin.isActive {
            coinImageView.image = UIImage(named: coin.type == "coin" ? "active" : "inactive")
        } else {
            coinImageView.image = UIImage(named: "inactive")
        }
        newTagLabel.isHidden = !coin.isNew
    }
}
