import UIKit
import SnapKit
import DesignPackage

class AddressView: UIView {

    // MARK: - UI Components

    let titleLabel = UILabel()
    let dropdownButton = UIButton(type: .system)
    private let stackView = UIStackView()

    // MARK: - Icons
    private let downImage = UIImage(
        systemName: "chevron.down",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.iconPointSize, weight: .medium)
    )?.withRenderingMode(.alwaysTemplate)

    private let upImage = UIImage(
        systemName: "chevron.up",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.iconPointSize, weight: .medium)
    )?.withRenderingMode(.alwaysTemplate)

    // MARK: - Constants

    private enum Constants {
        static let titleFontSize: CGFloat = 12
        static let buttonFontSize: CGFloat = 16
        static let iconPointSize: CGFloat = 14
        static let titleColor: UIColor = .secondaryTitlesGrey
        static let buttonTextColor: UIColor = .mainTitlesDark
        static let buttonIconColor: UIColor = .mainTitlesDark
        static let spacing: CGFloat = 2
        static let imageInset: CGFloat = 5
        static let minTextWidthPadding: CGFloat = 30
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setArrowDown()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        // Title Label
        titleLabel.text = "Delivery Address"
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        titleLabel.textColor = Constants.titleColor

        // Dropdown Button
        dropdownButton.setTitle("Select delivery address", for: .normal)
        dropdownButton.setTitleColor(Constants.buttonTextColor, for: .normal)
        dropdownButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonFontSize)
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.tintColor = Constants.buttonIconColor
        dropdownButton.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: Constants.imageInset,
            bottom: 0,
            right: -Constants.imageInset
        )
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.titleLabel?.textAlignment = .left
        
        let minWidth = calculateMinWidthForDropdownText()
        dropdownButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(minWidth)
        }

        // Stack View
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.spacing
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dropdownButton)

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Width Calculation

    private func calculateMinWidthForDropdownText() -> CGFloat {
        let font = UIFont.systemFont(ofSize: Constants.buttonFontSize)
        let text = "Select delivery address" as NSString
        let size = text.boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).size
        return ceil(size.width) + Constants.minTextWidthPadding
    }

    // MARK: - Public Methods

    func setArrowDown() {
        dropdownButton.setImage(downImage, for: .normal)
    }

    func setArrowUp() {
        dropdownButton.setImage(upImage, for: .normal)
    }
}
