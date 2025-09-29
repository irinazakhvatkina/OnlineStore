//
//  AppColors+Enam.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 29/09/25.
//

import UIKit

enum AppColors {
    case primaryBlue
    case buttonLightBlue
    case iconsLightBlue
    case sectionsVanilla
    case mainTitlesDark
    case secondaryTitlesGrey
    case screenBackgroundLightGrey
    case warningRed
    
    var uiColor: UIColor {
        switch self {
        case .primaryBlue:
            return UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1)
        case .buttonLightBlue:
            return UIColor(red: 81/255, green: 130/255, blue: 239/255, alpha: 1)
        case .iconsLightBlue:
            return UIColor(red: 146/255, green: 177/255, blue: 245/255, alpha: 1)
        case .sectionsVanilla:
            return UIColor(red: 252/255, green: 238/255, blue: 200/255, alpha: 1)
        case .mainTitlesDark:
            return UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1)
        case .secondaryTitlesGrey:
            return UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 1)
        case .screenBackgroundLightGrey:
            return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        case .warningRed:
            return UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 0.85)
        }
    }
}
