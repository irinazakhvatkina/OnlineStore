//
//  UITextField + Ext.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 20/10/25.
//

import UIKit

extension UITextField {
    func setLeftImage(_ image: UIImage?, tintColor: UIColor = .gray) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        container.addSubview(imageView)
        imageView.center = container.center
        
        self.leftView = container
        self.leftViewMode = .always
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
