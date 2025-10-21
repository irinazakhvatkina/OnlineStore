//
//  PhotoPickerManager.swift
//  OnlineStore
//
//  Created by Zarina Sadykova on 21.10.25.
//
import UIKit

class PhotoPickerManager: NSObject {
    
    // MARK: - Properties
    weak var delegate: ChangePhotoPopupDelegate?
    private weak var presentingViewController: UIViewController?
    
    // MARK: - Public Methods
    func presentPhotoPicker(from viewController: UIViewController) {
        print("🟡 PhotoPickerManager: Opening photo library")
        self.presentingViewController = viewController
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .fullScreen
        
        viewController.present(imagePicker, animated: true) {
            print("✅ PhotoPickerManager: Photo library opened")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoPickerManager: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("🟡 Photo selected from library")
        
        guard let image = info[.originalImage] as? UIImage else {
            print("❌ Failed to get image")
            picker.dismiss(animated: true)
            return
        }
        
        print("✅ Image loaded: \(image.size)")
        
        // ПРЯМОЙ способ - находим AccountViewController и обновляем напрямую
        if let accountVC = findAccountViewController() {
            print("🎯 Found AccountViewController directly")
            picker.dismiss(animated: true) {
                accountVC.updateProfileAvatar(image)
                print("✅ Avatar updated DIRECTLY!")
            }
        } else {
            // Если не нашли, используем делегат
            print("🟡 Using delegate method")
            picker.dismiss(animated: true) {
                self.delegate?.didSelectImage(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("ℹ️ Photo selection cancelled")
        picker.dismiss(animated: true)
    }
    
    private func findAccountViewController() -> AccountViewController? {
        // Ищем через window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }
        
        // Ищем в иерархии контроллеров
        func findInHierarchy(_ controller: UIViewController) -> AccountViewController? {
            if let accountVC = controller as? AccountViewController {
                return accountVC
            }
            
            if let navController = controller as? UINavigationController {
                for child in navController.viewControllers {
                    if let accountVC = findInHierarchy(child) {
                        return accountVC
                    }
                }
            }
            
            if let tabController = controller as? UITabBarController {
                for child in tabController.viewControllers ?? [] {
                    if let accountVC = findInHierarchy(child) {
                        return accountVC
                    }
                }
            }
            
            if let presented = controller.presentedViewController {
                return findInHierarchy(presented)
            }
            
            return nil
        }
        
        return findInHierarchy(rootViewController)
    }
}
