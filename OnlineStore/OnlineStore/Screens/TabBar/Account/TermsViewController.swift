//
//  TermsViewController.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 15.10.25.
//
import UIKit
import DesignPackage

class TermsConditionsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.screenBackgroundLightGrey.cgColor
        bottomBorder.frame = CGRect(x: 0, y: 98, width: UIScreen.main.bounds.width, height: 2)
        view.layer.addSublayer(bottomBorder)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms & Conditions"
        label.font = UIFont(name: FontNames.semiBold_18pt, size: 15)
        label.textColor = .mainTitlesDark
        label.textAlignment = .center
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let backImage = UIImage(systemName: "arrow.left")
        button.setImage(backImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        label.font = UIFont(name: FontNames.regular_18pt, size: 16)
        label.textColor = .mainTitlesDark
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Скрываем стандартный navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add scroll view and content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add content
        contentView.addSubview(frameView)
        frameView.addSubview(titleLabel)
        frameView.addSubview(backButton)
        contentView.addSubview(textLabel)
    }
    
    private func setupConstraints() {
        // Scroll View - начинается от самого верха экрана
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Content View
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        // Frame View - поднимаем выше на 50% (отрицательный отступ)
        frameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-50) // Поднимаем на 50 пунктов выше
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(99)
        }
        
        // Back Button - внутри frameView
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        // Title Label - внутри frameView
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(8)
        }
        
        // Text Label
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(frameView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    private func setupNavigationBar() {
        // Navigation bar скрыт, используем кастомную кнопку
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
