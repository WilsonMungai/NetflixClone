//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-21.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    // cell identifier
    static let identifier = "TitleCollectionViewCell"
    
    // poster image view
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    // MARK: - Public func
    public func configure(with model: String) {
//        guard let url = URL(string: model) else { return }
//        posterImageView.sd_setImage(with: url, completed: nil)
        // construct url to fetch images
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        // caching image using sdWeb
        posterImageView.sd_setImage(with: url, completed: nil)
//        print(model)
    }
}
