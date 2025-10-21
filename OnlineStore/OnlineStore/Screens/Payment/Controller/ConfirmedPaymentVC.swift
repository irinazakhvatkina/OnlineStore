//
//  ConfirmedPaymentVC.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 20/10/25.
//


import UIKit
import SnapKit

final class ConfirmedPaymentVC: UIViewController {
    
    private let mainView = ConfirmedPaymentView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        modalPresentationStyle = .overFullScreen
//        modalTransitionStyle = .crossDissolve
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        mainView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        mainView.continueButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
