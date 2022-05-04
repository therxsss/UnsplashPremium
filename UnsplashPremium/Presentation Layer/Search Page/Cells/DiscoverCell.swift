//
//  DiscoverCell.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 27.04.2022.
//

import UIKit
import SnapKit
import AlamofireImage

typealias DiscoverCellConfigurator = CollectionCellConfigurator<DiscoverCell, APIResponse>

class DiscoverCell: UICollectionViewCell {
    static var reuseId: String = "DiscoverCell"
    
    
    let discoverImage = UIImageView()
    let nameOfAuthor = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        discoverImage.backgroundColor = .orange
        addSubview(discoverImage)
        addSubview(nameOfAuthor)
        
        discoverImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        nameOfAuthor.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.left.equalToSuperview().offset(8)
        }
    }
}

// MARK: - Configurable Cell
extension DiscoverCell: ConfigurableCell{
    typealias DataType = APIResponse
    func configure(data: DataType) {
        guard let url = URL(string: data.results[0].urls.small) else { return }
        discoverImage.af.setImage(withURL: url)
    }
    
    func configure(data: DiscoverCellEntity) {
        guard let url = URL(string: data.regular) else { return }
        discoverImage.af.setImage(withURL: url)
    }

}
