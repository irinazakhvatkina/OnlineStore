//
//  CustomTabBarController.swift
//  OnlineStore
//
//  Created by Administration  on 29/09/25.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // for active title
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: AppColors.primaryBlue.uiColor], for: .selected)
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        addShadow()
        setupTabs()
    }

    func setupTabs() {
        let hvc = MainViewController()
        hvc.tabBarItem = UITabBarItem(title: "Home",
                                        image: UIImage.homeInactive,
                                        selectedImage: UIImage.homeActive.withRenderingMode(.alwaysOriginal))
            
        let wvc = WishlistViewController()
        wvc.tabBarItem = UITabBarItem(title: "Wishlist",
                                        image: UIImage.wishlistInactive,
                                        selectedImage: UIImage.wishlistActive.withRenderingMode(.alwaysOriginal))
            
        let mvc = ManagerViewController()
        mvc.tabBarItem = UITabBarItem(title: "Manager",
                                        image: UIImage.paperInactive,
                                        selectedImage: UIImage.paperActive.withRenderingMode(.alwaysOriginal))

        let svc = SearchViewController()
        svc.tabBarItem = UITabBarItem(title: "Search",
                                        image: UIImage.searchInactive,
                                        selectedImage: UIImage.searchActive.withRenderingMode(.alwaysOriginal))
            
        let avc = AccountViewController()
        avc.tabBarItem = UITabBarItem(title: "Account",
                                        image: UIImage.accountInactive,
                                        selectedImage: UIImage.accountActive.withRenderingMode(.alwaysOriginal))
            
        viewControllers = [hvc, wvc, mvc, svc, avc]
    }

    func addShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowRadius = 5
        tabBar.layer.masksToBounds = false
    }
}
