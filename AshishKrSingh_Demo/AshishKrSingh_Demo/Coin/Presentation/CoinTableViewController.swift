//
//  CoinTableViewController.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import UIKit

class CoinTableViewController: UIViewController {
    private let tableView = UITableView()
    private let searchButton = UIButton(type: .system)
    private let filterView = FilterView()
    private var searchController: UISearchController?
    private let activityIndicator = UIActivityIndicatorView(style: .large) // Add activity indicator
    
    private var viewModel: CoinViewModel
    private var coins: [Coin] = []

    init(viewModel: CoinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        showLoader() // Show loader when fetch starts
        viewModel.fetchCoins()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        // Navigation Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Coins"
        configureNavigationBar(for: navigationController)

        setupSearch()
        navigationItem.hidesSearchBarWhenScrolling = false

        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem = searchBarButton

        // Table View
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        // Filter View
        view.addSubview(filterView)
        filterView.onSelectionChanged = { [weak self] selectedItem in
            self?.viewModel.filterCoins(withFilters: Array(selectedItem), searchText: self?.searchController?.searchBar.text ?? "")
        }

        activityIndicator.color = UIColor(red: 89.0 / 255.0, green: 13.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        // Layout Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor),

            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 120),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        searchController?.searchBar.placeholder = "Search Coins"
        configureNavigationBar(for: navigationController)
    }

    func configureNavigationBar(for navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 89.0 / 255.0, green: 13.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)

        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance

        navigationController.navigationBar.prefersLargeTitles = true

        if let searchController = searchController {
            searchController.searchBar.tintColor = .black
            searchController.searchBar.searchTextField.textColor = UIColor(red: 89.0 / 255.0, green: 13.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
            searchController.searchBar.searchTextField.backgroundColor = .white
        }
    }

    @objc private func openSearch() {
        if navigationItem.searchController != nil {
            navigationItem.searchController?.searchBar.removeFromSuperview()
            navigationItem.searchController = nil
            DispatchQueue.main.async {
                if self.searchController?.isFirstResponder ?? false {
                    self.searchController?.resignFirstResponder()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.navigationItem.searchController = self.searchController
            }
        }
    }

    private func setupBindings() {
        viewModel.onCoinsUpdated = { [weak self] coins in
            self?.coins = coins
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Loader Methods
    private func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    private func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CoinTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: coins[indexPath.row])
        return cell
    }
}

// MARK: - UISearchResultsUpdating, UISearchControllerDelegate
extension CoinTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            viewModel.filterCoins(withFilters: filterView.getSelectedItems(), searchText: "")
            return
        }
        viewModel.filterCoins(withFilters: filterView.getSelectedItems(), searchText: query)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            if searchController.isFirstResponder {
                searchController.resignFirstResponder()
            }
        }
    }
}
