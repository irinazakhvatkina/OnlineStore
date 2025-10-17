//
//  CustomTabBarController.swift
//  OnlineStore
//
//  Created by Administration  on 29/09/25.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK: - Properties
    private var isManagerMode: Bool {
        let savedType = UserDefaults.standard.string(forKey: "accountType") ?? "client"
        return savedType == "manager"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // for active title
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: AppColors.primaryBlue.uiColor], for: .selected)
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        addShadow()
        setupTabs()
        setupNotifications()
        
        // Устанавливаем начальную вкладку - Account (последний индекс)
        setInitialTab()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAccountTypeChange),
            name: NSNotification.Name("AccountTypeDidChange"),
            object: nil
        )
    }
    
    @objc private func handleAccountTypeChange() {
        let currentTabTitle = selectedViewController?.tabBarItem.title
        setupTabs()
        DispatchQueue.main.async {
            if let tabTitle = currentTabTitle,
               let indexToRestore = self.viewControllers?.firstIndex(where: { $0.tabBarItem.title == tabTitle }) {
                self.selectedIndex = indexToRestore
            } else {
                self.selectedIndex = (self.viewControllers?.count ?? 1) - 1
            }
        }
    }

    private func setInitialTab() {
        selectedIndex = (viewControllers?.count ?? 1) - 1
    }
    
    func setupTabs() {
        // Создаем основные контроллеры
        let hvc = MainViewController()
        let hvcNav = UINavigationController(rootViewController: hvc)
        hvcNav.tabBarItem = UITabBarItem(title: "Home",
                                        image: UIImage.homeInactive,
                                        selectedImage: UIImage.homeActive.withRenderingMode(.alwaysOriginal))
            
        let wvc = WishlistViewController()
        let wvcNav = UINavigationController(rootViewController: wvc)
        wvcNav.tabBarItem = UITabBarItem(title: "Wishlist",
                                        image: UIImage.wishlistInactive,
                                        selectedImage: UIImage.wishlistActive.withRenderingMode(.alwaysOriginal))
            
        let svc = SearchViewController()
        let svcNav = UINavigationController(rootViewController: svc)
        svcNav.tabBarItem = UITabBarItem(title: "Search",
                                        image: UIImage.searchInactive,
                                        selectedImage: UIImage.searchActive.withRenderingMode(.alwaysOriginal))
            
        let avc = AccountViewController()
        let avcNav = UINavigationController(rootViewController: avc)
        avcNav.tabBarItem = UITabBarItem(title: "Account",
                                        image: UIImage.accountInactive,
                                        selectedImage: UIImage.accountActive.withRenderingMode(.alwaysOriginal))
        
        if isManagerMode {
            // Режим менеджера - 5 вкладок
            let mvc = ManagerViewController()
            let mvcNav = UINavigationController(rootViewController: mvc)
            mvcNav.tabBarItem = UITabBarItem(title: "Manager",
                                          image: UIImage.paperInactive,
                                          selectedImage: UIImage.paperActive.withRenderingMode(.alwaysOriginal))
            
            viewControllers = [hvcNav, wvcNav, mvcNav, svcNav, avcNav]
        } else {
            // Режим клиента - 4 вкладки
            viewControllers = [hvcNav, wvcNav, svcNav, avcNav]
        }
    }

    func addShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowRadius = 5
        tabBar.layer.masksToBounds = false
    }
}
