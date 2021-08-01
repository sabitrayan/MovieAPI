//
//  MovieDetailVC_2.swift
//  MovieAPI
//
//  Created by ryan on 7/31/21.
//

import UIKit
import SDWebImage

class MovieDetailVC_2: UIViewController {
    weak var delegate: MovieDetailHeaderDelegate?
    
    var isFavorite: Bool = false {
        didSet{
            isFavorite ?
                (favoriteView.image = UIImage(systemName: "star.fill")) :
                (favoriteView.image = UIImage(systemName: "star"))
        }
    }

    private var viewModel = MovieDetailVM(service: MovieService())

    var id: Int?

    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        label.layer.cornerRadius = 5
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()


    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()

    private lazy var favoriteView: UIImageView = {
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
        delegate?.didTapFavoriteButton(isFavorite: isFavorite)
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


    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupObserver()
        view.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        setupNavigationBar()
        DispatchQueue.main.async { [self] in
            viewModel.fetchMovieDetail(id: id ?? 10)
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = "News"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }

    private func setupObserver() {
        viewModel.movieDetail.producer.startWithResult { [weak self] (_) in
            self?.dateLabel.text = self?.viewModel.year
            self?.titleLabel.text = self?.viewModel.title
            self?.ratingLabel.text = String(self?.viewModel.rating ?? 0)
            if let url = URL(string: self?.viewModel.detailImageUrl ?? "" ) {
                self?.movieImageView.sd_setImage(with: url)
            }
            self?.descriptionLabel.text = self?.viewModel.overview
            self?.navigationItem.title = self?.viewModel.title
        }
    }

    private func setupConstraints() {
        view.addSubview(movieImageView)
        view.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(circleStarView)
        view.addSubview(circleRatingView)
        circleRatingView.addSubview(ratingLabel)
        circleStarView.addSubview(favoriteView)

        circleRatingView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(110)
            make.left.equalToSuperview().inset(30)
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
            make.top.equalToSuperview().inset(110)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        movieImageView.snp.makeConstraints { make in
            make.height.equalTo(240)
            make.top.equalToSuperview().inset(87)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).inset(-20)
            make.left.right.equalToSuperview().inset(10)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(movieImageView.snp.bottom).inset(40)
            $0.left.equalToSuperview().inset(15)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(15)
        }
    }
}

