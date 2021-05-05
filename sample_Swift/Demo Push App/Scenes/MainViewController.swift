//
//  ViewController.swift
//  Demo Push App
//
//  Created by alex on 13.04.2021.
//

import UIKit
import ZGRImSDK

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var deviceTokenTextView: UITextView!
    @IBOutlet weak var installationIdTextView: UITextView!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var externalUserIdField: UITextField!
    @IBOutlet weak var phoneNumberTextView: UITextField!
    @IBOutlet weak var externalUserIdTextView: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let token = appDelegate.deviceToken {
            deviceTokenUpdated(token)
        }
        
        NotificationCenter.default.addObserver(forName: .deviceTokenUpdated, object: nil, queue: nil, using: {
            [weak self] note in
            if let self = self, let token = (note.userInfo?["deviceToken"] as? Data ?? nil) {
                self.deviceTokenUpdated(token)
            }
        })
        
        installationIdTextView.text = UIDevice.current.identifierForVendor?.uuidString
    }
    
    // MARK: - Actions
    @IBAction func onSendPhoneNumberTap(_ sender: Any) {
        
        if phoneNumberField.text?.count == 0 {
            self.ext_showAlertWithTitle("Не заполнен номер телефона")
        }
        
        guard let userPhone = phoneNumberField.text else { return }
        
        let correctPhoneNumber = ZGRMessaging.sharedInstance().saveUserPhoneNumber(userPhone) { [weak self] _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.ext_showAlertWithTitle("Номер телефона успешно сохранен")
            }
        }
        
        phoneNumberField.textColor = correctPhoneNumber ? .black : .red
    }
    
    @IBAction func onPersonalizeTap(_ sender: Any) {
        
        if externalUserIdField.text?.count == 0 {
            self.ext_showAlertWithTitle("Не заполнен externalUserId")
        }
        
        guard let externalUserID = externalUserIdField.text else { return }
        
        ZGRMessaging.sharedInstance().personalize(withExternalUserId: externalUserID) { [weak self] _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.ext_showAlertWithTitle("Персонализировано")
            }
        }
    }
    
    @IBAction func onGetProfileTap(_ sender: Any) {
        ZGRMessaging.sharedInstance().fetchUser() { [weak self] user, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if user == nil {
                    self.ext_showAlertWithTitle("Не персонализировано")
                }
                self.phoneNumberField.text = user?.phoneNumber ?? "Отсутствует"
                self.externalUserIdTextView.text = user?.externalUserId ?? "Отсутствует"
            }
        }
    }
    
    @IBAction func onLogoutTap(_ sender: Any) {
        ZGRMessaging.sharedInstance().depersonalize() { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.onGetProfileTap([])
                
                self.phoneNumberField.text = ""
                self.externalUserIdTextView.text = ""
                
                self.ext_showAlertWithTitle("Выполнена деперсонализация, все локальные данные удалены")
            }
        }
    }
    
    @IBAction func onDoneTap(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // MARK: - Private
    private func deviceTokenUpdated(_ deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        DispatchQueue.main.async {
            self.deviceTokenTextView.text = token
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        phoneNumberField.resignFirstResponder()
        externalUserIdField.resignFirstResponder()
    }
}

