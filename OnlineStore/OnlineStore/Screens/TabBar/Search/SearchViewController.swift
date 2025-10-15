import UIKit
import SnapKit
import DesignPackage

final class SearchViewController: UIViewController, UISearchBarDelegate {

    // MARK: - UI
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search here..."
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.3
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.clearButtonMode = .never
        
        return searchBar
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .white
            cv.isHidden = true
            return cv
        }()
    private let tableView = UITableView()
    private var loadingIndicator: UIActivityIndicatorView!

    // MARK: - Data
    private var searchHistory: [String] = []
    private var searchResults: [Product] = []
    private var isShowingHistory = true

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setupGestureToHideKeyboard()
        
        loadSearchHistory()
    }

    // MARK: - Setup
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.identifier)

        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(tableView)
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)

        searchBar.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)

    }

    // MARK: - Constraints
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(cancelButton.snp.left).offset(-8) 
            make.height.equalTo(40)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.right.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        cancelButton.isHidden = true
        isShowingHistory = true
        tableView.isHidden = false
        collectionView.isHidden = true
        tableView.reloadData()
    }

    @objc private func searchTextChanged() {
        if let searchText = searchBar.text, !searchText.isEmpty {
            cancelButton.isHidden = false
            performSearch(query: searchText)
        } else {
            cancelButton.isHidden = true
            isShowingHistory = true
            tableView.isHidden = false
            collectionView.isHidden = true
            tableView.reloadData()
        }
    }

    private func performSearch(query: String) {
        loadingIndicator.startAnimating()
        
        Task {
            do {
                let products = try await fetchProducts(for: query)
                self.searchResults = products
                self.isShowingHistory = false
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            } catch {
                print("Error fetching products: \(error)")
                showErrorAlert()
            }
            loadingIndicator.stopAnimating()
        }
    }


    private func addToHistory(_ query: String) {
        if let index = searchHistory.firstIndex(of: query) {
            searchHistory.remove(at: index)
        }
        searchHistory.insert(query, at: 0)
        if searchHistory.count > 10 {
            searchHistory.removeLast()
        }
        saveSearchHistory()
    }


    private func loadSearchHistory() {
        if let savedHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
            searchHistory = savedHistory
        }
    }

    private func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        addToHistory(query)
        performSearch(query: query)
    }

    // MARK: - Networking
    private func fetchProducts(for query: String) async throws -> [Product] {
        let endpoint = Endpoint.search(query: query)
        let products: [Product] = try await APIManager.shared.fetchData(endpoint: endpoint, type: [Product].self)
        return products
    }

    // MARK: - Alerts
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "An error occurred while fetching products. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showNoResultsAlert() {
        let alert = UIAlertController(title: "No Results", message: "No products found for this search.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingHistory {
            return searchHistory.isEmpty ? 1 : searchHistory.count + 1
        } else {
            return searchResults.isEmpty ? 1 : searchResults.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingHistory {
            if searchHistory.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "No search history yet."
                cell.textLabel?.textColor = .gray
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == searchHistory.count {
                // Clear All - cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Clear All"
                cell.textLabel?.textColor = .red
                cell.textLabel?.textAlignment = .center
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryCell.identifier, for: indexPath) as! SearchHistoryCell
                let query = searchHistory[indexPath.row]
                cell.configure(with: query)
                cell.onDeleteTapped = { [weak self] in
                    self?.searchHistory.remove(at: indexPath.row)
                    self?.saveSearchHistory()
                    self?.tableView.reloadData()
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            if searchResults.isEmpty {
                cell.textLabel?.text = "🧐 Nothing found! Try a different keyword."
                cell.textLabel?.textColor = .gray
                cell.selectionStyle = .none
            } else {
                let product = searchResults[indexPath.row]
                cell.textLabel?.text = product.title
                cell.textLabel?.textColor = .black
                cell.selectionStyle = .default
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()

        if isShowingHistory {
            if searchHistory.isEmpty {
                return
            }
            if indexPath.row == searchHistory.count {
                // clean history
                searchHistory.removeAll()
                saveSearchHistory()
                tableView.reloadData()
            } else {
                let selectedQuery = searchHistory[indexPath.row]
                searchBar.text = selectedQuery
                performSearch(query: selectedQuery)
            }
        } else {
            let product = searchResults[indexPath.row]
            let detailVC = ProductDetailsVC(product: product)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard isShowingHistory, !searchHistory.isEmpty, indexPath.row < searchHistory.count else { return nil }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.searchHistory.remove(at: indexPath.row)
            self?.saveSearchHistory()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let product = searchResults[indexPath.item]
        let isInCart = CartManager.shared.contains(product)
        cell.configure(with: product, isProductInCart: isInCart)
        cell.onAddToCart = { [weak self] in
            guard let self = self else { return }
            if !CartManager.shared.contains(product) {
                CartManager.shared.add(product)
                collectionView.reloadItems(at: [indexPath])
                NotificationCenter.default.post(name: .cartUpdated, object: nil)
                self.showToast(message: "Item added to cart")
            } else {
                self.showToast(message: "This item is already in the cart")
            }
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = searchResults[indexPath.item]
        let detailVC = ProductDetailsVC(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}
