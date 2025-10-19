import UIKit
import SnapKit
import DesignPackage

class UpdateProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UISearchBarDelegate {

    // MARK: - UI Elements

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search here..."
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.secondaryTitlesGrey.cgColor
        textField.layer.borderWidth = 1.3
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .mainTitlesDark
        textField.clearButtonMode = .never
        
        return searchBar
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
    private let titleField = UITextField()

    private let priceLabel = UILabel()
    private let priceField = UITextField()

    private let categoryLabel = UILabel()
    private let categoryField = UITextField()
    private let categoryPicker = UIPickerView()
    private let dropdownIcon = UIImageView(image: UIImage(systemName: "chevron.down"))

    private let descriptionLabel = UILabel()
    private let descriptionField = UITextView()

    private let clearDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.isHidden = true
        return button
    }()

    private let imagesLabel = UILabel()
    private let imagesField = UITextField()

    private let saveButton = UIButton(type: .system)

    private var categories: [String] = []

    private var isPickerOpen = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Update product"

        setupUI()
        fetchCategories()
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11)
            make.left.right.equalToSuperview().inset(11)
            make.height.equalTo(44)
        }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        func setupLabel(_ label: UILabel, withText text: String) {
            label.text = text
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textColor = .mainTitlesDark
            label.textAlignment = .left
            label.setContentHuggingPriority(.required, for: .horizontal)
        }

        setupLabel(titleLabel, withText: "Title")
        setupLabel(priceLabel, withText: "Price")
        setupLabel(categoryLabel, withText: "Category")
        setupLabel(descriptionLabel, withText: "Description")
        setupLabel(imagesLabel, withText: "Images")

        func setupTextField(_ textField: UITextField) {
            textField.borderStyle = .roundedRect
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.clearButtonMode = .whileEditing
            textField.delegate = self
        }

        setupTextField(titleField)
        setupTextField(priceField)
        priceField.keyboardType = .decimalPad

        setupTextField(categoryField)
        categoryField.placeholder = "Select category"
        categoryField.inputView = categoryPicker
        categoryField.clearButtonMode = .never
        categoryField.rightView = dropdownIcon
        categoryField.rightViewMode = .always
        dropdownIcon.tintColor = .gray
        dropdownIcon.contentMode = .scaleAspectFit
        dropdownIcon.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }

        categoryField.addTarget(self, action: #selector(categoryFieldEditingDidBegin), for: .editingDidBegin)
        categoryField.addTarget(self, action: #selector(categoryFieldEditingDidEnd), for: .editingDidEnd)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneBtn], animated: false)
        categoryField.inputAccessoryView = toolbar

        descriptionField.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.cornerRadius = 6
        descriptionField.font = UIFont.systemFont(ofSize: 16)
        descriptionField.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        descriptionField.delegate = self

        setupTextField(imagesField)

        let stack = UIStackView(arrangedSubviews: [
            createRow(label: titleLabel, inputView: titleField),
            createRow(label: priceLabel, inputView: priceField),
            createRow(label: categoryLabel, inputView: categoryField),
            createRow(label: descriptionLabel, inputView: descriptionField, isTextView: true),
            createRow(label: imagesLabel, inputView: imagesField)
        ])
        stack.axis = .vertical
        stack.spacing = 20

        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        contentView.addSubview(clearDescriptionButton)
        clearDescriptionButton.addTarget(self, action: #selector(clearDescription), for: .touchUpInside)
        clearDescriptionButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionField.snp.top).offset(6)
            make.right.equalTo(descriptionField.snp.right).offset(-6)
            make.width.height.equalTo(24)
        }

        saveButton.setTitle("Save changes", for: .normal)
        saveButton.backgroundColor = .buttonLightBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.addTarget(self, action: #selector(saveProduct), for: .touchUpInside)
        contentView.addSubview(saveButton)

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(150)
            make.left.equalToSuperview().offset(100)
            make.width.equalTo(190)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }

        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }

    // MARK: - Helper Methods

    private func createRow(label: UILabel, inputView: UIView, isTextView: Bool = false) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, inputView])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center

        label.snp.makeConstraints { make in
            make.width.equalTo(100)
        }

        if isTextView {
            inputView.snp.makeConstraints { make in
                make.height.equalTo(100)
            }
        } else {
            inputView.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }
        return stack
    }

    // MARK: - UIPickerViewDataSource & Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { categories.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { categories[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categories[row]
    }

    // MARK: - Actions

    @objc private func dismissPicker() {
        categoryField.resignFirstResponder()
    }

    private func fetchCategories() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let fetched = ["Electronics", "Clothing", "Books", "Home", "Toys"]
            DispatchQueue.main.async {
                self.categories = fetched
                self.categoryPicker.reloadAllComponents()
            }
        }
    }

    @objc private func saveProduct() {
        guard let title = titleField.text, !title.isEmpty,
              let priceText = priceField.text, let price = Double(priceText),
              let category = categoryField.text, !category.isEmpty,
              !descriptionField.text.isEmpty,
              let images = imagesField.text, !images.isEmpty else {
            showAlert(message: "Please fill all fields")
            return
        }

        print("Saving product: Title: \(title), Price: \(price), Category: \(category), Description: \(descriptionField.text!), Images: \(images)")
        showAlert(title: "Success", message: "Product saved!")
    }

    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Dropdown Icon Rotation

    @objc private func categoryFieldEditingDidBegin() {
        isPickerOpen = true
        rotateDropdownIcon(open: true)
    }

    @objc private func categoryFieldEditingDidEnd() {
        isPickerOpen = false
        rotateDropdownIcon(open: false)
    }

    private func rotateDropdownIcon(open: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.dropdownIcon.transform = open ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }

    // MARK: - Clear Description Button

    func textViewDidChange(_ textView: UITextView) {
        clearDescriptionButton.isHidden = textView.text.isEmpty
    }

    @objc private func clearDescription() {
        descriptionField.text = ""
        clearDescriptionButton.isHidden = true
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Searching for: \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
