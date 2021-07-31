//
//  MovieDetailCell.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import UIKit

class MovieDetailCell: UITableViewCell {

    static let reuseIdentifier = String(describing: MovieDetailCell.self)
    var viewModel: MovieDetailVM? {
        didSet {
            setup()
        }
    }

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        descriptionLabel.text = viewModel.overview
    }
}
