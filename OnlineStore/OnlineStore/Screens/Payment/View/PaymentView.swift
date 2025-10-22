import UIKit
import SnapKit

final class PaymentView: UIView {
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let existingCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Select existing card"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private let cardNumberField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Card number"
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 8
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.backgroundColor = .clear
        tf.setLeftImage(UIImage(systemName: "creditcard"))
        return tf
    }()

    private let expiryDateField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "MM/YY"
        tf.keyboardType = .numbersAndPunctuation
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.setLeftPadding(12)
        return tf
    }()

    private let cvvField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "CVV"
        tf.isSecureTextEntry = true
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.setLeftPadding(12) 
        return tf
    }()

    private let confirmButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Confirm payment", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 10
        btn.isEnabled = false
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private let stackView = UIStackView()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(existingCardLabel)
        mainStackView.addArrangedSubview(cardNumberField)
        mainStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(expiryDateField)
        horizontalStackView.addArrangedSubview(cvvField)
        mainStackView.addArrangedSubview(confirmButton)
    }
    
    private func setupConstraints() {
        
        mainStackView.snp.makeConstraints { make in
            
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        cardNumberField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        expiryDateField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        cvvField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    func returnCardNumberField() -> UITextField { cardNumberField }
    func returnExpiryDateField() -> UITextField { expiryDateField }
    func returnCvvField() -> UITextField { cvvField }
    func returnConfirmButton() -> UIButton { confirmButton }

}
