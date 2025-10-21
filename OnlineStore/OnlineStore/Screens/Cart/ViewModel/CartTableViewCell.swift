import UIKit
import SnapKit
import SDWebImage

// MARK: - CartTableViewCellDelegate

protocol CartTableViewCellDelegate: AnyObject {
    func didTapPlus(in cell: CartTableViewCell)
    func didTapMinus(in cell: CartTableViewCell)
    func didToggleCheckbox(in cell: CartTableViewCell, isSelected: Bool)
    func didTapDelete(in cell: CartTableViewCell)

}

// MARK: - CartTableViewCell

class CartTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    weak var delegate: CartTableViewCellDelegate?

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        return view
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    private let variantLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "increaseButton"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()

    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "reduceButton"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()

    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(named: "checkedIcon"), for: .selected)
        button.tintColor = .lightGray
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = false
        clipsToBounds = false

        setupSubviews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(checkboxButton)
        containerView.addSubview(productImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(variantLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(minusButton)
        buttonStackView.addArrangedSubview(quantityLabel)
        buttonStackView.addArrangedSubview(plusButton)
        buttonStackView.addArrangedSubview(deleteButton)
        
       
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        checkboxButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        productImageView.snp.makeConstraints { make in
            make.leading.equalTo(checkboxButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.top)
            make.leading.equalTo(productImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }

        variantLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }

        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productImageView.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
        }

        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }

        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(14)
        }
        
        minusButton.snp.remakeConstraints { make in
            make.width.height.equalTo(14)
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containerView.layer.shadowPath = UIBezierPath(
                roundedRect: self.containerView.bounds,
                cornerRadius: self.containerView.layer.cornerRadius
            ).cgPath
        }
    }

    private func setupActions() {
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

    }

    // MARK: - Actions
    
    @objc private func plusTapped() {
        delegate?.didTapPlus(in: self)
    }

    @objc private func minusTapped() {
        delegate?.didTapMinus(in: self)
    }
    
    @objc private func deleteTapped() {
        delegate?.didTapDelete(in: self)
    }

    @objc private func checkboxTapped() {
        checkboxButton.isSelected.toggle()
        delegate?.didToggleCheckbox(in: self, isSelected: checkboxButton.isSelected)
    }

    // MARK: - Configure
    
    func configure(with item: CartItem) {
        titleLabel.text = item.title
        variantLabel.text = "Variant: \(item.variant)"
        priceLabel.text = item.price
        quantityLabel.text = "\(item.quantity)"
        if let imageURLString = item.product.images.first,
           let url = URL(string: imageURLString) {
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
        } else {
            productImageView.image = UIImage(named: "placeholderImage")
        }
    }

    func configure(with item: CartItem, currencyCode: String) {
        titleLabel.text = item.title
        variantLabel.text = "Variant: \(item.variant)"
        
        if let priceDouble = Double(item.price) {
            let convertedPrice = CurrencyManager.shared.convert(priceInUSD: priceDouble, to: currencyCode) ?? priceDouble
            priceLabel.text = convertedPrice.formattedPrice(currencyCode: currencyCode)
        } else {
            priceLabel.text = item.price
        }
        
        quantityLabel.text = "\(item.quantity)"
        
        if let imageURLString = item.product.images.first,
           let url = URL(string: imageURLString) {
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
        } else {
            productImageView.image = UIImage(named: "placeholderImage")
        }
    }


    func setSelectedCheckbox(_ selected: Bool) {
        checkboxButton.isSelected = selected
    }
}
