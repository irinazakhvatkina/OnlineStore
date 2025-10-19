import UIKit
import SnapKit
import DesignPackage

class ManagerViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Manager"

        addNavigationBarBottomLine()
        setupProductsSection()
        setupCategoriesSection()
    }

    // MARK: - Navigation Bar

    func addNavigationBarBottomLine() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let bottomLine = UIView(frame: CGRect(x: 0, y: navigationBar.frame.height - 1, width: navigationBar.frame.width, height: 1))
        bottomLine.backgroundColor = .systemGray5
        navigationBar.addSubview(bottomLine)
    }

    // MARK: - Products Section

    private func setupProductsSection() {
        let titleLabel = UILabel()
        titleLabel.text = "Products"
        titleLabel.font = UIFont(name: "Inter-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .mainTitlesDark
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(61)
            make.height.equalTo(17)
        }

        let underline = UIView()
        underline.backgroundColor = .systemGray5
        view.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(304)
            make.height.equalTo(0.5)
        }

        let addButton = createButton(title: "Add new product", action: #selector(openAddProduct))
        let updateButton = createButton(title: "Update product", action: #selector(openUpdateProduct))

        let stack = UIStackView(arrangedSubviews: [addButton, updateButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .equalSpacing

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(underline.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(308)
        }
    }

    // MARK: - Categories Section

    private func setupCategoriesSection() {
        let titleLabel = UILabel()
        titleLabel.text = "Categories"
        titleLabel.font = UIFont(name: "Inter-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .mainTitlesDark
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60 + 17 + 8 + 50 * 2 + 16 * 3 + 40)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(81)
            make.height.equalTo(17)
        }

        let underline = UIView()
        underline.backgroundColor = .systemGray5
        view.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(304)
            make.height.equalTo(0.5)
        }

        let addButton = createButton(title: "Create category", action: #selector(categoryActionPlaceholder))
        let updateButton = createButton(title: "Update category", action: #selector(categoryActionPlaceholder))

        let stack: UIStackView = UIStackView(arrangedSubviews: [addButton, updateButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .equalSpacing

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(underline.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(308)
        }
    }

    // MARK: - Button Factory

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter", size: 16) ?? UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .buttonLightBlue
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return button
    }

    // MARK: - Actions

    @objc private func openAddProduct() {
        let addVC = AddNewProductViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }

    @objc private func openUpdateProduct() {
        let updateVC = UpdateProductViewController()
        navigationController?.pushViewController(updateVC, animated: true)
    }

    // Заглушка для категорий
    @objc private func categoryActionPlaceholder() {
        let alert = UIAlertController(title: "Заглушка", message: "Эта кнопка пока не реализована", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
