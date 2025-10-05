

import UIKit
import SnapKit
import DesignPackage

class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: FontNames.medium_18pt, size: 14)
        label.textColor = .mainTitlesDark
        label.numberOfLines = 1
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = .mainTitlesDark
                contentView.backgroundColor = .white
                contentView.layer.cornerRadius = 10
                
                contentView.layer.shadowColor = UIColor(red: 0.09, green: 0.28, blue: 0.75, alpha: 1).cgColor // #1648C0
                contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
                contentView.layer.shadowRadius = 3
                contentView.layer.shadowOpacity = 1
                
                contentView.layer.masksToBounds = false
            } else {
                titleLabel.textColor = .mainTitlesDark
                contentView.backgroundColor = .clear
                contentView.layer.cornerRadius = 0
                
                contentView.layer.shadowOpacity = 0
                contentView.layer.shadowRadius = 0
                contentView.layer.shadowOffset = .zero
                contentView.layer.masksToBounds = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.masksToBounds = true
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: Category) {
        titleLabel.text = category.name
    }
}
