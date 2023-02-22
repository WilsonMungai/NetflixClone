//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-21.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    // Movie Image
    private let titlePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // activate auto layout attribute
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // prevents image from overflowing
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Movie Name
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Play Button
    private let playButton: UIButton = {
        let button = UIButton()
        // change the image size
        let image = (UIImage(systemName: "play.circle",
                             withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)))
        button.setImage(image , for: .normal)
        button.tintColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style , reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlePoster)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private func
    private func applyConstraints() {
        let titlePosterConstraint = [
            titlePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titlePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titlePoster.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        let titleLabelConstraint = [
            titleLabel.leadingAnchor.constraint(equalTo:titlePoster.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        // activate constraint
        NSLayoutConstraint.activate(titlePosterConstraint)
        NSLayoutConstraint.activate(titleLabelConstraint)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    // MARK: - Public func
    public func configure(with model: TitleViewModel) {
//        guard let url = URL(string: model.posterURL) else { return }
//        titlePoster.sd_setImage(with: url, completed: nil)
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        // caching image using sdWeb
        titlePoster.sd_setImage(with: url, completed: nil)
//        print(model)
        titleLabel.text = model.titleName
    }
    
}
