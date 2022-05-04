//
//  SectionHeader.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 27.04.2022.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
    
    static let reuseId = "SectionHeader"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(text: String, font: UIFont?, textColor: UIColor) {
        title.textColor = textColor
        title.font = font
        title.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
