//
//  MovieDetailVC.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import UIKit
import SDWebImage

class MovieDetailVC: UITableViewController {

    private let viewModel = MovieDetailVM(service: MovieService())

    private let id: Int

    init(id: Int) {
        self.id = id
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTableView()
        setupObserver()
        viewModel.fetchMovieDetail(id: id)
    }

    private func setupTableView() {
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: MovieDetailCell.reuseIdentifier)
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }

    private func setupObserver() {
        viewModel.movieDetail.producer.startWithResult { [weak self] (_) in
            self?.tableView.reloadData()

        }
    }
}

extension MovieDetailVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCell.reuseIdentifier, for: indexPath) as? MovieDetailCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MovieDetailHeader(viewModel: viewModel)
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 280

    }
}
