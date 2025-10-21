//
//  ChangePhotoPopupDelegate.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 21.10.25.
//

import UIKit

protocol ChangePhotoPopupDelegate: AnyObject {
    func didSelectTakePhoto()
    func didSelectChooseFromFile()
    func didSelectDeletePhoto()
    func didSelectImage(_ image: UIImage)
}
