//
//  ProfileIcon.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 13.10.25.
//

// ProfileAvatarView.swift
import UIKit
import SnapKit

protocol ProfileAvatarViewDelegate: AnyObject {
    func profileAvatarViewDidTapEdit(_ view: ProfileAvatarView)
    func profileAvatarViewDidTapAvatar(_ view: ProfileAvatarView)
}

class ProfileAvatarView: UIView {
    
    // MARK: - UI Elements
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfilePhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Edit"), for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray6.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: ProfileAvatarViewDelegate?
    
    var avatarImage: UIImage? {
        get { avatarImageView.image }
        set { avatarImageView.image = newValue }
    }
    
    var editButtonImage: UIImage? {
        get { editButton.image(for: .normal) }
        set { editButton.setImage(newValue, for: .normal) }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(avatarImageView)
        addSubview(editButton)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(34)
        }
    }
    
    private func setupActions() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    private func updateCornerRadius() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        editButton.layer.cornerRadius = editButton.frame.width / 2
    }
    
    // MARK: - Actions
    @objc private func editButtonTapped() {
        delegate?.profileAvatarViewDidTapEdit(self)
    }
    
    @objc private func avatarTapped() {
        delegate?.profileAvatarViewDidTapAvatar(self)
    }
    
    // MARK: - Public Methods
    func setAvatarImage(_ image: UIImage?) {
        avatarImageView.image = image
    }
    
    func setAvatarSystemImage(_ systemName: String, tintColor: UIColor = .systemBlue) {
        avatarImageView.image = UIImage(systemName: systemName)
        avatarImageView.tintColor = tintColor
    }
    
    func setEditButtonImage(_ image: UIImage?, for state: UIControl.State = .normal) {
        editButton.setImage(image, for: state)
    }
    
    func configureEditButton(backgroundColor: UIColor = .white,
                           borderColor: UIColor = .systemGray6,
                           borderWidth: CGFloat = 2) {
        editButton.backgroundColor = backgroundColor
        editButton.layer.borderColor = borderColor.cgColor
        editButton.layer.borderWidth = borderWidth
    }
}
