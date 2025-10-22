import UIKit
import SnapKit

final class ConfirmedPaymentView: UIView {
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .gray
        return btn
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.layer.masksToBounds = true
        return v
    }()
    
    private let successImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.seal.fill")
        iv.tintColor = UIColor(red: 0.45, green: 0.75, blue: 0.66, alpha: 1)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Congrats! your payment\nis successfully"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Track your order or just chat directly to the seller.\nDownload order summary in down below"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .gray
        return lbl
    }()
    
     let pdfView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lightGray.cgColor
        return v
    }()
    
    private let pdfIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "doc.richtext.fill")
        iv.tintColor = UIColor(red: 0.25, green: 0.45, blue: 1, alpha: 1)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let pdfLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "order_invoice"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let downloadIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.down.circle")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btn.backgroundColor = UIColor(red: 0.45, green: 0.75, blue: 0.66, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(successImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(pdfView)
        containerView.addSubview(continueButton)
        
        pdfView.addSubview(pdfIcon)
        pdfView.addSubview(pdfLabel)
        pdfView.addSubview(downloadIcon)
        
        containerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        successImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(successImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        pdfView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(56)
        }
        
        pdfIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        pdfLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pdfIcon.snp.trailing).offset(8)
        }
        
        downloadIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(22)
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(pdfView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
