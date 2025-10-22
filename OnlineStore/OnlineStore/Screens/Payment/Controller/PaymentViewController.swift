import UIKit

final class PaymentViewController: UIViewController {
    
    private let mainView = PaymentView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Payment method"
        setupBackButton()
        setupTextFields()
        setupActions()
    }
    
    private func setupTextFields() {
        mainView.returnCardNumberField().delegate = self
        mainView.returnExpiryDateField().delegate = self
        mainView.returnCvvField().delegate = self
        [mainView.returnCardNumberField(), mainView.returnExpiryDateField(), mainView.returnCvvField()].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    private func setupActions() {
        mainView.returnConfirmButton().addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
      }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .mainTitlesDark
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
      
      // MARK: - Actions
      
      @objc private func confirmTapped() {
         let vc = ConfirmedPaymentVC()
          present(vc, animated: true)
      }
      
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateFields()
    }
    
    private func validateFields() {
        let cardValid = mainView.returnCardNumberField().text?.count == 16
        let expiryValid = mainView.returnExpiryDateField().text?.count == 5
        let cvvValid = mainView.returnCvvField().text?.count == 3
        
        let allValid = cardValid && expiryValid && cvvValid
        
        mainView.returnConfirmButton().isEnabled = allValid
        mainView.returnConfirmButton().backgroundColor = allValid ? UIColor(red: 0.45, green: 0.75, blue: 0.66, alpha: 1) : .lightGray
    }
}


extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // MARK: - Card number (16 digits only)
        if textField == mainView.returnCardNumberField() {
            let allowedChars = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: allowedChars.inverted) != nil { return false }
            
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            return newLength <= 16
        }
        
        // MARK: - Expiry Date (MM/YY with auto-slash)
        if textField == mainView.returnExpiryDateField() {
            let allowedChars = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: allowedChars.inverted) != nil && string != "" { return false }
            
            var currentText = textField.text ?? ""
            
            if string == "" {
                textField.text = String(currentText.dropLast())
                return false
            }
            
            if currentText.count == 2 {
                currentText.append("/")
            }
            
            textField.text = (currentText + string).prefix(5).description
            return false
        }
        
        // MARK: - CVV (3 digits only)
        if textField == mainView.returnCvvField() {
            let allowedChars = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: allowedChars.inverted) != nil { return false }
            
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            return newLength <= 3
        }
        
        return true
    }
}
