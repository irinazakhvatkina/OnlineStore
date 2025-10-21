import UIKit
import DesignPackage

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // for active title
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.primaryBlue], for: .selected)
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        addShadow()
        setupTabs()
    }

    func setupTabs() {
        let hvc = MainViewController()
        let hNav = UINavigationController(rootViewController: hvc)
        hNav.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage.homeInactive,
                                       selectedImage: UIImage.homeActive.withRenderingMode(.alwaysOriginal))

        let wvc = WishlistViewController()
        let wNav = UINavigationController(rootViewController: wvc)
        wNav.tabBarItem = UITabBarItem(title: "Wishlist",
                                       image: UIImage.wishlistInactive,
                                       selectedImage: UIImage.wishlistActive.withRenderingMode(.alwaysOriginal))

        let mvc = PaymentViewController()//ManagerViewController()
        let mNav = UINavigationController(rootViewController: mvc)
        mNav.tabBarItem = UITabBarItem(title: "Manager",
                                       image: UIImage.paperInactive,
                                       selectedImage: UIImage.paperActive.withRenderingMode(.alwaysOriginal))

        let svc = SearchViewController()
        let sNav = UINavigationController(rootViewController: svc)
        sNav.tabBarItem = UITabBarItem(title: "Search",
                                       image: UIImage.searchInactive,
                                       selectedImage: UIImage.searchActive.withRenderingMode(.alwaysOriginal))

        let avc = AccountViewController()
        let aNav = UINavigationController(rootViewController: avc)
        aNav.tabBarItem = UITabBarItem(title: "Account",
                                       image: UIImage.accountInactive,
                                       selectedImage: UIImage.accountActive.withRenderingMode(.alwaysOriginal))

        viewControllers = [hNav, wNav, mNav, sNav, aNav]
    }


    func addShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowRadius = 5
        tabBar.layer.masksToBounds = false
    }
}
