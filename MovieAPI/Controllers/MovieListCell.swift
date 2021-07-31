//
//  MovieListCell.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import UIKit
import SnapKit

protocol MovieDetailHeaderDelegate: AnyObject {
    func didTapFavoriteButton()
}

class MovieListCell: UITableViewCell {

    weak var delegate: MovieDetailHeaderDelegate?
    var isFavorite: Bool = false

    static let reuseIdentifier = String(describing: MovieListCell.self)

    var viewModel: MovieVM? {
        didSet {
            setup()
        }
    }

    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 0
        iv.clipsToBounds = true

        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let stackViewPage: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private let spaceView: UIView = {
        var view = UIView()
        return view
    }()

    lazy var favoriteView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "star")
        iv.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavoriteButton))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()


    @objc private func didTapFavoriteButton() {
        isFavorite.toggle()
        isFavorite ?
            (favoriteView.image = UIImage(systemName: "star.fill")) :
            (favoriteView.image = UIImage(systemName: "star"))
        delegate?.didTapFavoriteButton()
    }


    lazy var circleRatingView: UIView = {
        let circle = UIView()

        circle.contentMode = UIView.ContentMode.scaleAspectFill
        circle.layer.cornerRadius = 25
        circle.layer.masksToBounds = false
        circle.backgroundColor  = .white
        return circle
    }()

    lazy var circleStarView: UIView = {
        let circle = UIView()

        circle.contentMode = UIView.ContentMode.scaleAspectFill
        circle.layer.cornerRadius = 25
        circle.layer.masksToBounds = false
        circle.backgroundColor  = .white
        return circle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        contentView.addSubview(movieImageView)
        contentView.addSubview(spaceView)
        contentView.addSubview(stackViewPage)
        contentView.addSubview(circleStarView)
        contentView.addSubview(circleRatingView)
        circleRatingView.addSubview(ratingLabel)
        circleStarView.addSubview(favoriteView)


        circleRatingView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        ratingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()

            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        favoriteView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        circleStarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        [titleLabel, dateLabel].forEach{
            stackViewPage.addArrangedSubview($0)
        }
        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview().inset(20)
        }

        spaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
            make.top.equalTo(movieImageView.snp.bottom).offset(5)
        }

        stackViewPage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalToSuperview().offset(300)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
        dateLabel.text = viewModel.releaseDate
        if let url = URL(string: viewModel.coverImageURL) {
            movieImageView.sd_setImage(with: url)
        }
    }
}
