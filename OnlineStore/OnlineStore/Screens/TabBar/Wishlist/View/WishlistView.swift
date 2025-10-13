import UIKit
import SnapKit

class WishlistView: UIView {
    
    // MARK: - Separator
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.939, green: 0.949, blue: 0.945, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    // MARK: - SearchBar
    public var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.939, green: 0.949, blue: 0.945, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        
        let placeholderText = "Search here..."
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 17)
            ]
        )
        
    
        let image = UIImage(named: "SearchInactive") ?? UIImage(systemName: "magnifyingglass")!
        let iconView = UIImageView(image: image)
        iconView.contentMode = .scaleAspectFit
        
      
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        iconView.frame = CGRect(x: 8, y: 0, width: 24, height: 24)
        containerView.addSubview(iconView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        
        return searchBar
    }()
    
    // MARK: - CollectionView
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupSubviews() {
        addSubview(searchBar)
        addSubview(separatorView)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().inset(15)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(22)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Public
    func returnCollectionView() -> UICollectionView { collectionView }

}
