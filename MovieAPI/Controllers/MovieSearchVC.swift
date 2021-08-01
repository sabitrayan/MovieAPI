//
//  MovieSearchVC.swift
//  MovieAPI
//
//  Created by ryan on 8/1/21.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class MovieSearchVC: UITableViewController {

    private let searchController = UISearchController()
    private let viewModel = MovieSearchVM(service: MovieService(), state: .begin)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        configureSearchController()
        setupObserver()
    }


    deinit {
        viewModel.clearObservation()
        print("Clear observation for Movie Search screen")
    }

    private func setupObserver() {
        viewModel.movies.producer.startWithResult { [weak self] (_) in
            self?.tableView.reloadData()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Movie Search"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.2862745098, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    private func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.searchTextField.returnKeyType = .done
        navigationItem.searchController = searchController

        searchController.searchBar.searchTextField.reactive
            .controlEvents(.editingChanged)
            .debounce(0.5, on: QueueScheduler.main)
            .observeValues { [weak self] (textField) in
                if let text = textField.text, text.count > 0 {
                    self?.viewModel.searchMovies(searchKey: text)
                }

            }
    }

    private func setupTableView() {
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 400
        tableView.showsVerticalScrollIndicator = false
    }

   
}

extension MovieSearchVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRowsInSection(section) == 0 {
            tableView.setEmptyMessage(message: viewModel.setTextResult(), size: 20)
        } else {
            tableView.restore()
        }

        return viewModel.numberOfRowsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        let movie = viewModel.movieAtIndex(indexPath.row)
        cell.viewModel = MovieVM(movie: movie)
        return cell
    }
}

extension MovieSearchVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.movieAtIndex(indexPath.row).id
        let controller = MovieDetailVC_2()
        controller.id = id
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MovieSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchKey = searchController.searchBar.text else { return }
        if searchKey.count == 0 {
            viewModel.state = .begin
            viewModel.movies.value.removeAll()
        }
    }
}

extension MovieSearchVC: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}
