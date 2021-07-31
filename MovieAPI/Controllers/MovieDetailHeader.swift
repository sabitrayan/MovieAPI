//
//  MovieDetailHeader.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import UIKit
import SDWebImage

class MovieDetailHeader: UIView {

    weak var delegate: MovieDetailHeaderDelegate?
    private let viewModel: MovieDetailVM
    var isFavorite: Bool = false


    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBackground
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
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

    init(viewModel: MovieDetailVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        if let url = URL(string: viewModel.detailImageUrl) {
            movieImageView.sd_setImage(with: url)
        }
        //backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        addSubview(movieImageView)
        addSubview(dateLabel)
        addSubview(titleLabel)

        movieImageView.snp.makeConstraints { make in
            make.height.equalTo(240)
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(movieImageView.snp.bottom).inset(40)
            $0.left.equalToSuperview().inset(15)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(15)
        }

        dateLabel.text = viewModel.year
        titleLabel.text = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



