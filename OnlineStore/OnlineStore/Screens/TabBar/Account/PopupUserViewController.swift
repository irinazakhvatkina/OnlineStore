//
//  Untitled.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 15.10.25.
//
import UIKit

protocol AccountTypePopupDelegate: AnyObject {
    func didSelectAccountType(_ type: AccountType)
}

class AccountTypePopupViewController: UIViewController {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change account type"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let clientButton = PopupActionButton(
        title: "Client",
        style: .withIcon("Bag")
    )
    
    private let managerButton = PopupActionButton(
        title: "Manager",
        style: .withIcon("Paper")
    )
    
    // MARK: - Properties
    weak var delegate: AccountTypePopupDelegate?
    private var currentAccountType: AccountType = .client
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Configuration
    func configure(with currentType: AccountType) {
        self.currentAccountType = currentType
        updateSelection()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Add subviews
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(clientButton)
        buttonsStackView.addArrangedSubview(managerButton)
    }
    
    private func setupConstraints() {
        // Container view - 328x260
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(328)
            make.height.equalTo(260)
        }
        
        // Title label
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Buttons stack view
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        clientButton.addTarget(self, action: #selector(clientButtonTapped), for: .touchUpInside)
        managerButton.addTarget(self, action: #selector(managerButtonTapped), for: .touchUpInside)
        
        // Tap outside to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateSelection() {
        clientButton.setSelected(currentAccountType == .client)
        managerButton.setSelected(currentAccountType == .manager)
    }
    
    // MARK: - Actions
    @objc private func clientButtonTapped() {
        showNotification(message: "You get client account")
        delegate?.didSelectAccountType(.client)
    }
    
    @objc private func managerButtonTapped() {
        showNotification(message: "You get manager account")
        delegate?.didSelectAccountType(.manager)
    }
    
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Notification
    private func showNotification(message: String) {
        let notificationView = UIView()
        notificationView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        notificationView.layer.cornerRadius = 12
        notificationView.alpha = 0
        notificationView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        notificationView.addSubview(label)
        
        // Добавляем на window чтобы было поверх всего
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(notificationView)
            
            notificationView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(window.safeAreaLayoutGuide).offset(-100)
                make.leading.trailing.equalToSuperview().inset(40)
                make.height.greaterThanOrEqualTo(60)
            }
            
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
            
            // Анимация появления
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
                notificationView.alpha = 1
                notificationView.transform = CGAffineTransform.identity
            } completion: { _ in
                // Анимация исчезновения после задержки
                UIView.animate(withDuration: 0.3, delay: 2.0, options: []) {
                    notificationView.alpha = 0
                    notificationView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                } completion: { _ in
                    notificationView.removeFromSuperview()
                    // Закрываем попап только после того как нотификация исчезла
                    self.dismiss(animated: true)
                }
            }
        } else {
            // Fallback - добавляем на текущий view и сразу закрываем
            view.addSubview(notificationView)
            
            notificationView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
                make.leading.trailing.equalToSuperview().inset(40)
                make.height.greaterThanOrEqualTo(60)
            }
            
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
            
            UIView.animate(withDuration: 0.3) {
                notificationView.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 2.0) {
                    notificationView.alpha = 0
                } completion: { _ in
                    notificationView.removeFromSuperview()
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension AccountTypePopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}
//import UIKit
//
//protocol AccountTypePopupDelegate: AnyObject {
//    func didSelectAccountType(_ type: AccountType)
//    func didSelectManagerWithPassword()
//}
//
//class AccountTypePopupViewController: UIViewController {
//    
//    // MARK: - UI Elements
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 12
//        view.clipsToBounds = true
//        return view
//    }()
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Change account type"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        label.textColor = .black
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private let buttonsStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        stackView.alignment = .center
//        return stackView
//    }()
//    
//    private let clientButton = PopupActionButton(
//        title: "Client",
//        style: .withIcon("Bag")
//    )
//    
//    private let managerButton = PopupActionButton(
//        title: "Manager",
//        style: .withIcon("Paper")
//    )
//    
//    // MARK: - Properties
//    weak var delegate: AccountTypePopupDelegate?
//    private var currentAccountType: AccountType = .client
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//        setupActions()
//    }
//    
//    // MARK: - Configuration
//    func configure(with currentType: AccountType) {
//        self.currentAccountType = currentType
//        updateSelection()
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        
//        // Add subviews
//        view.addSubview(containerView)
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(buttonsStackView)
//        
//        buttonsStackView.addArrangedSubview(clientButton)
//        buttonsStackView.addArrangedSubview(managerButton)
//    }
//    
//    private func setupConstraints() {
//        // Container view - 328x260
//        containerView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(328)
//            make.height.equalTo(260)
//        }
//        
//        // Title label
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(24)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
//        
//        // Buttons stack view
//        buttonsStackView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(32)
//            make.leading.trailing.equalToSuperview().inset(16)
//        }
//    }
//    
//    private func setupActions() {
//        clientButton.addTarget(self, action: #selector(clientButtonTapped), for: .touchUpInside)
//        managerButton.addTarget(self, action: #selector(managerButtonTapped), for: .touchUpInside)
//        
//        // Tap outside to dismiss
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
//        tapGesture.delegate = self
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    private func updateSelection() {
//        clientButton.setSelected(currentAccountType == .client)
//        managerButton.setSelected(currentAccountType == .manager)
//    }
//    
//    // MARK: - Actions
//    @objc private func clientButtonTapped() {
//        delegate?.didSelectAccountType(.client)
//        dismiss(animated: true)
//    }
//    
//    @objc private func managerButtonTapped() {
//        // Вместо непосредственного переключения, запрашиваем пароль
//        dismiss(animated: true) { [weak self] in
//            self?.delegate?.didSelectManagerWithPassword()
//        }
//    }
//    
//    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
//        let location = gesture.location(in: view)
//        if !containerView.frame.contains(location) {
//            dismiss(animated: true)
//        }
//    }
//}
//
//// MARK: - UIGestureRecognizerDelegate
//extension AccountTypePopupViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return touch.view == view
//    }
//}
