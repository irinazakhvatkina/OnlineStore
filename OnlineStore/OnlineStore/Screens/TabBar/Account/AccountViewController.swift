//
//  AccountViewController.swift
//  OnlineStore
//
//  Created by Administration  on 29/09/25.
//

// AccountViewController.swift
import UIKit
import DesignPackage

class AccountViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont(name: FontNames.semiBold_18pt, size: 15)
        label.textColor = .mainTitlesDark
        label.textAlignment = .center
        return label
    }()
    
    private let profileAvatarView: ProfileAvatarView = {
        let view = ProfileAvatarView()
        return view
    }()
    
    private let developerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "iCodePro Developer"
        label.font = UIFont(name: FontNames.regular_18pt, size: 16)
        label.textColor = .mainTitlesDark
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "icode@gmail.com"
        label.font = UIFont(name: FontNames.regular_18pt, size: 14)
        label.textColor = .secondaryTitlesGrey
        label.textAlignment = .center

        let attributedString = NSMutableAttributedString(string: "icode@gmail.com")
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        label.attributedText = attributedString
        
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15 // Расстояние между кнопками 15
        stackView.backgroundColor = .clear // Убираем фон
        return stackView
    }()
    
    private let accountTypeButton = ProfileButtonView(
        title: "Type of account"
    )

    private let termsButton = ProfileButtonView(
        title: "Terms & Conditions"
    )

    private let logoutButton = ProfileButtonView(
        title: "Log out",
        showArrow: false,
        customIconName: "signout"
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGray
        
        // Add scroll view and content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add profile section
        contentView.addSubview(profileTitleLabel)
        contentView.addSubview(profileAvatarView)
        contentView.addSubview(developerNameLabel)
        contentView.addSubview(emailLabel)
        
        // Add buttons stack view
        contentView.addSubview(buttonsStackView)
        
        // Add buttons to stack view
        buttonsStackView.addArrangedSubview(accountTypeButton)
        buttonsStackView.addArrangedSubview(termsButton)
        buttonsStackView.addArrangedSubview(logoutButton)
        
        // Убираем фиксированную высоту, так как она уже задана в ProfileButtonView
        // и stackView сам управляет расположением
    }
    
    private func setupConstraints() {
        // Scroll View
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Content View
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        // Profile Title
        profileTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Profile Avatar View
        profileAvatarView.snp.makeConstraints { make in
            make.top.equalTo(profileTitleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(27)
            make.width.height.equalTo(100)
        }
        
        // Developer Name
        developerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileAvatarView.snp.top).offset(14)
            make.leading.equalTo(profileAvatarView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }

        // Email
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(developerNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileAvatarView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        // Buttons Stack View
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(350)
            make.leading.trailing.equalToSuperview().inset(27)
            make.bottom.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    private func setupActions() {
        // Profile Avatar View actions
        profileAvatarView.delegate = self
        
        // Button actions
        accountTypeButton.tapAction = { [weak self] in
            self?.accountTypeTapped()
        }
        
        termsButton.tapAction = { [weak self] in
            self?.termsTapped()
        }
        
        logoutButton.tapAction = { [weak self] in
            self?.logoutTapped()
        }
    }
    
    // MARK: - Actions
    private func accountTypeTapped() {
        print("Account type tapped")
        // Handle account type action
    }
    
    private func termsTapped() {
        print("Terms & Conditions tapped")
        // Handle terms action
    }
    
    private func logoutTapped() {
        print("Logout tapped")
        // Handle logout action
    }
}

// MARK: - ProfileAvatarViewDelegate
extension AccountViewController: ProfileAvatarViewDelegate {
    func profileAvatarViewDidTapEdit(_ view: ProfileAvatarView) {
        print("Edit button tapped - open photo editor")
        // Handle edit photo action
    }
    
    func profileAvatarViewDidTapAvatar(_ view: ProfileAvatarView) {
        print("Avatar tapped - open full screen view or change photo")
        // Handle avatar tap action
    }
}
