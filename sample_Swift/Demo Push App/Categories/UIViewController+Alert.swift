//
//  UIViewController+Alert.swift
//  Demo Push App
//
//  Created by alex on 14.04.2021.
//

import UIKit

extension UIViewController {
    
    func ext_showAlertWithTitle(_ title: String) {
        self.ext_showAlertWithTitle(title, message: "")
    }
    
    func ext_showAlertWithTitle(_ title: String, message mess:String) {
        if presentedViewController != nil { return }
        
        let alertController = UIAlertController.init(title: title, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
}
