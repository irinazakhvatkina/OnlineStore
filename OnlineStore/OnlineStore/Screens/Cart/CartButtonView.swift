import UIKit
import SnapKit
import DesignPackage

public class CartButtonView: UIView {

    public var onTap: (() -> Void)?

    private let button = UIButton(type: .system)
    private let badgeView = UIView()
    private let countLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 44, height: 44)
    }

    public func updateCount(_ count: Int) {
        if count > 0 {
            badgeView.isHidden = false
            countLabel.text = "\(count)"
        } else {
            badgeView.isHidden = true
        }
    }

    private func setupUI() {
        let image = UIImage(named: "cart")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        addSubview(button)

        badgeView.backgroundColor = .warningRed
        badgeView.layer.cornerRadius = 8
        badgeView.isHidden = true
        badgeView.clipsToBounds = true
        addSubview(badgeView)

        countLabel.font = .systemFont(ofSize: 8, weight: .bold)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        badgeView.addSubview(countLabel)
    }

    private func setupConstraints() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        badgeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().offset(-2)
            $0.width.height.equalTo(16)
        }

        countLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
