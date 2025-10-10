import UIKit
import SnapKit
import DesignPackage

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    private let pages = OnboardingPage.allPages
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupScrollView()
        setupPages()
        setupPageControl()
        setupButtons()
        updateButtonForCurrentPage()
        updatePageControlDots()
    }
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = page
        updateButtonForCurrentPage()
        updatePageControlDots()
    }
    
    private func updatePageControlDots() {
        guard #available(iOS 14.0, *) else { return }
        guard let normalDot = UIImage(named: "pageDotUnselected"),
              let selectedDot = UIImage(named: "pageDotSelected") else {
            return
        }

        for index in 0..<pageControl.numberOfPages {
            pageControl.setIndicatorImage(normalDot, forPage: index)
        }

        let currentPage = pageControl.currentPage
        pageControl.setIndicatorImage(selectedDot, forPage: currentPage)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = page
        updateButtonForCurrentPage()
        updatePageControlDots()
    }
    
    // MARK: - Setup ScrollView
    
    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setup Pages
    
    private func setupPages() {
        for (index, page) in pages.enumerated() {
            let pageView = createPageView(for: page)
            scrollView.addSubview(pageView)
            
            pageView.snp.makeConstraints { make in
                make.top.bottom.equalTo(scrollView)
                make.width.equalTo(view)
                make.height.equalTo(scrollView)
                
                if index == 0 {
                    make.leading.equalTo(scrollView.snp.leading)
                } else {
                    make.leading.equalTo(scrollView.subviews[index - 1].snp.trailing)
                }
                
                if index == pages.count - 1 {
                    make.trailing.equalTo(scrollView.snp.trailing)
                }
            }
        }
    }
    
    // MARK: - Setup PageControl
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        
        pageControl.currentPageIndicatorTintColor = .primaryBlue
        pageControl.pageIndicatorTintColor = .lightGray
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        if #available(iOS 14.0, *) {
            guard
                let normalDot = UIImage(named: "pageDotUnselected"),
                let selectedDot = UIImage(named: "pageDotSelected")
            else {
                print("❌ Индикаторы не найдены в Assets!")
                return
            }
            
            for index in 0..<pages.count {
                pageControl.setIndicatorImage(normalDot, forPage: index)
            }
            pageControl.setIndicatorImage(selectedDot, forPage: pageControl.currentPage)
        }
        
    }
    
    // MARK: - Setup PageView
    
    private func createPageView(for page: OnboardingPage) -> UIView {
        let container = UIView()
        
        let shadowContainer = UIView()
        shadowContainer.layer.cornerRadius = 36
        shadowContainer.layer.shadowColor = UIColor(red: 22/255, green: 72/255, blue: 192/255, alpha: 0.8).cgColor
        shadowContainer.layer.shadowOpacity = 1
        shadowContainer.layer.shadowOffset = CGSize(width: 8, height: 16)
        shadowContainer.layer.shadowRadius = 20
        shadowContainer.clipsToBounds = false
        
        let trapezoidImageView = TrapezoidImageView()
        trapezoidImageView.image = UIImage(named: page.imageName)
        trapezoidImageView.contentMode = .scaleAspectFill
        trapezoidImageView.layer.cornerRadius = 36
        trapezoidImageView.clipsToBounds = true
        
        shadowContainer.addSubview(trapezoidImageView)
        trapezoidImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.addSubview(shadowContainer)
        shadowContainer.snp.makeConstraints { make in
            make.width.equalTo(341)
            make.height.equalTo(482)
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = page.title
        titleLabel.font = UIFont(name: FontNames.semiBold_28pt, size: 40)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .primaryBlue
        
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(shadowContainer.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        if let description = page.description {
            let descriptionLabel = UILabel()
            descriptionLabel.text = description
            descriptionLabel.font = UIFont(name: FontNames.medium_18pt, size: 20)
            descriptionLabel.textAlignment = .left
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textColor = .secondaryTitlesGrey
            
            container.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.leading.trailing.equalToSuperview().inset(30)
            }
        }
        return container
    }
    
    // MARK: - Setup Buttons
    
    private func setupButtons() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.mainTitlesDark, for: .normal)
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 10
        nextButton.layer.shadowColor = UIColor(red: 22/255, green: 72/255, blue: 192/255, alpha: 1).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        nextButton.layer.shadowRadius = 10
        nextButton.layer.shadowOpacity = 1
        nextButton.alpha = 1
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageControl.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(31)
        }
    }
    
    private func updateButtonForCurrentPage() {
        let currentIndex = pageControl.currentPage
        let currentPage = pages[currentIndex]
        nextButton.setTitle(currentPage.buttonTitle, for: .normal)
        animateButtonShake(repeatCount: 2)
    }
    
    private func animateButtonShake(repeatCount: Int, currentRepeat: Int = 0) {
        guard currentRepeat < repeatCount else {
            nextButton.transform = .identity
            return
        }
        let shakeDistance: CGFloat = 8
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.nextButton.transform = CGAffineTransform(translationX: -shakeDistance, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                self.nextButton.transform = CGAffineTransform(translationX: shakeDistance, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.nextButton.transform = .identity
            }
        }, completion: { _ in
            self.animateButtonShake(repeatCount: repeatCount, currentRepeat: currentRepeat + 1)
        })
    }
    
    // MARK: - Button Action
    
    @objc private func nextButtonTapped() {
        let currentPage = pageControl.currentPage
        let nextPage = currentPage + 1
        
        if nextPage < pages.count {
            let offset = CGPoint(x: CGFloat(nextPage) * view.frame.width, y: 0)
            scrollView.setContentOffset(offset, animated: true)
        } else {
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            
            let tabBarController = CustomTabBarController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarController
                UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
}
