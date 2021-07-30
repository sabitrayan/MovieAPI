//
//  MovieListCell.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import UIKit
import SnapKit
class MovieListCell: UITableViewCell {

    static let reuseIdentifier = String(describing: MovieListCell.self)

    var viewModel: MovieVM? {
        didSet {
            setup()
        }
    }

    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        iv.setDimensions(width: 450, height: 440)
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(movieImageView)
        addSubview(stackViewPage)
        [titleLabel, ratingLabel].forEach{
            stackViewPage.addArrangedSubview($0)
        }
        movieImageView.snp.makeConstraints { make in
            make.width.equalTo(420)
            make.height.equalTo(400)
            make.top.equalToSuperview()
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
        if let url = URL(string: viewModel.coverImageURL) {
            movieImageView.sd_setImage(with: url)
        }
    }
}
