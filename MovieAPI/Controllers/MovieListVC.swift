//
//  MovieListVC.swift
//  MovieAPI
//
//  Created by ryan on 5/30/21.
//

import UIKit
import ReactiveSwift

protocol MovieListVCDelegate: AnyObject {
    func didTapMenuButton()
}

class MovieListVC: UITableViewController {

    weak var delegate: MovieListVCDelegate?
    private let viewModel = MovieListVM(service: MovieService())
    private var isScrollToTop = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupObserver()
        viewModel.fetchMovies()
    }



    private func setupNavigationBar() {
        navigationItem.title = "News"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    }

    private func setupObserver() {
        viewModel.movies.producer.startWithResult { [weak self] _ in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
    private func setupTableView() {
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 400
        tableView.showsVerticalScrollIndicator = false
    }
}


extension MovieListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator

        let movie = viewModel.movieAtIndex(indexPath.row)
        cell.viewModel = MovieVM(movie: movie)
        return cell
    }
}

extension MovieListVC {

    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard
            let identifier = configuration.identifier as? String,
            let index = Int(identifier)
        else { return }

        let selectedMovieId = viewModel.movieAtIndex(index).id
        let controller = MovieDetailVC(id: selectedMovieId)
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension MovieListVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.movieAtIndex(indexPath.row).id
        let controller = MovieDetailVC(id: id)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MovieListVC {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        navigationItem.rightBarButtonItem?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.viewModel.fetchMoreMovies()
        }
    }
}
