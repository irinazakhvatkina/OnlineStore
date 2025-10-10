import UIKit
import WebKit
import SnapKit
import DesignPackage

final class SpecialForYouView: UIView {

    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.contentMode = .scaleAspectFit
        webView.clipsToBounds = true
        webView.layer.cornerRadius = 12
        return webView
    }()
    
    private let saleLabel: UILabel = {
        let label = UILabel()
        label.text = "SALE"
        label.font = UIFont(name: FontNames.semiBold_24pt, size: 50)
        label.textColor = .mainTitlesDark
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(webView)
        containerView.addSubview(saleLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(webView.snp.width).multipliedBy(0.8)
        }

        saleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }

    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid image URL")
            return
        }
        let htmlString = """
        <html><head><style>body,html{margin:0;padding:0;} img{width:100%%;height:auto;}</style></head>
        <body><img src="\(url.absoluteString)"/></body></html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
