//
//  TextFieldTableViewCell.swift
//  Demo Push App
//
//  Created by alex on 14.04.2021.
//

import UIKit

final class TextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    public var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    public var value: String {
        get { return textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    public var cellAction: ((String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForKeyboardNotifications()
    }
    
    // MARK: - Actions
    @IBAction func editEnd(_ sender: UITextField) {
        guard let action = cellAction else { return }
        action(sender.text ?? "")
    }
    
    @IBAction func editExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // MARK: - Keyboard
    func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if !textField.isFirstResponder || superview?.superview?.isKind(of: UITableView.self) == nil { return }
        
        if let tableView = superview?.superview as? UITableView,
            let endRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: endRect.size.height, right: 0.0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
            
            var rect = self.frame
            rect.size.height -= endRect.size.height
            if !rect.contains(textField.frame.origin) {
                tableView.scrollRectToVisible(textField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if !textField.isFirstResponder || superview?.superview?.isKind(of: UITableView.self) == nil { return }
        
        if let tableView = superview?.superview as? UITableView {
            let contentInsets = UIEdgeInsets.zero
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }
}

