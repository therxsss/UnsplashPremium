//
//  CategoryCell.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 27.04.2022.
//

import UIKit
import SnapKit
import AlamofireImage

typealias CategoryCellConfigurator = CollectionCellConfigurator<CategoryCell, APIResponse>
class CategoryCell: UICollectionViewCell{
    
    static var reuseId: String = "CategoryCell"
    
    let categoryImage = UIImageView()
    let categoryTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(categoryImage)
        categoryImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addSubview(categoryTitle)
        categoryTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryCell: ConfigurableCell{
    
    typealias DataType = APIResponse
    
    func configure(data: DataType) {
//        guard let url = URL(string: data.results[0].urls.small) else { return }
//        categoryImage.af.setImage(withURL: url)
    }
    
    func configure(data: CategoryCellEntity) {
        guard let url = URL(string: data.small) else { return }
        categoryImage.af.setImage(withURL: url)
    }
}
