//
//  MovieDetailHeader.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import UIKit
import SDWebImage

protocol MovieDetailHeaderDelegate: AnyObject {
    func didTapFavoriteButton()
}

class MovieDetailHeader: UIView {

    weak var delegate: MovieDetailHeaderDelegate?
    private let viewModel: MovieDetailVM
    var isFavorite: Bool = false

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBackground
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .label
        label.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        label.layer.cornerRadius = 10
        label.setDimensions(width: 90, height: 30)
        return label
    }()


    lazy var favoriteView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 25, height: 25)
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "star")
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavoriteButton))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()

    init(viewModel: MovieDetailVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubview(movieImageView)
        movieImageView.setDimensions(width: UIScreen.main.bounds.width, height: 240)
        movieImageView.centerX(inView: self)
        movieImageView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        if let url = URL(string: viewModel.detailImageUrl) {
            movieImageView.sd_setImage(with: url)
        }
        let frameSize = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350 )
        movieImageView.addGradient(frame: frameSize, start: .clear, end: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))

        addSubview(ratingLabel)
        ratingLabel.anchor(left: self.safeAreaLayoutGuide.leftAnchor,
                           bottom: movieImageView.bottomAnchor,
                           paddingLeft: 12,
                           paddingBottom: -35)
        ratingLabel.text = viewModel.rating

        addSubview(favoriteView)
        favoriteView.centerY(inView: ratingLabel)
        favoriteView.anchor(left: ratingLabel.rightAnchor, paddingLeft: 10)

        addSubview(titleLabel)
        titleLabel.anchor(top: movieImageView.bottomAnchor,
                          left: self.safeAreaLayoutGuide.leftAnchor,
                          right: self.safeAreaLayoutGuide.rightAnchor,
                          paddingTop: -50,
                          paddingLeft: 12,
                          paddingRight: 60)
        titleLabel.text = viewModel.titleAndYear

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapFavoriteButton() {
        isFavorite.toggle()
        isFavorite ?
            (favoriteView.image = UIImage(systemName: "star.fill")) :
            (favoriteView.image = UIImage(systemName: "star"))
        delegate?.didTapFavoriteButton()
    }

}
