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
        let stack = UIStackView(arrangedSubviews: [descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        addSubview(stack)
        stack.anchor(top: self.topAnchor,
                     left: self.safeAreaLayoutGuide.leftAnchor,
                     bottom: self.bottomAnchor,
                     right: self.safeAreaLayoutGuide.rightAnchor,
                     paddingTop: 20,
                     paddingLeft: 12,
                     paddingBottom: 20,
                     paddingRight: 12)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        descriptionLabel.text = viewModel.overview
    }
}
