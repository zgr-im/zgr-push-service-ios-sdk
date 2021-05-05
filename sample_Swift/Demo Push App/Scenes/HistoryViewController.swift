//
//  HistoryViewController.swift
//  Demo Push App
//
//  Created by alex on 15.04.2021.
//

import UIKit
import ZGRImSDK

final class HistoryViewController: UIViewController {
    
    @IBOutlet weak var pageItem: UIBarButtonItem!
    @IBOutlet weak var pageStepper: UIStepper!
    @IBOutlet weak var pageSizeControl: UISegmentedControl!
    
    @IBOutlet weak var fromSwitch: UISwitch!
    @IBOutlet weak var fromPicker: UIDatePicker!
    
    @IBOutlet weak var toSwitch: UISwitch!
    @IBOutlet weak var toPicker: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = DateFormatter()
    let request = ZGRDatabaseRequest()
    var notifications = [ZGRNotification]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup dateFormatter
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        
        // setup tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // fetch data
        fetchData()
    }
    
    // MARK: - Data
    func reloadData() {
        tableView.reloadData()
    }
    
    func fetchData() {
        ZGRMessaging.sharedInstance().fetchNotifications(with: request) { [weak self] notifications, error in
            guard let self = self, let notifArray = notifications else { return }
            
            self.notifications = notifArray
            DispatchQueue.main.async { self.reloadData() }
        }
    }
    
    func deleteObjectAtIndexPath(_ indexPath: IndexPath) {
        let index = indexPath.row
        let notification = notifications[index]
        
        ZGRMessaging.sharedInstance().delete(notification) { [weak self] success, _ in
            guard let self = self else { return }
            if !success { return }
            
            self.notifications.remove(at: index)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func onPageValueChange(_ sender: UIStepper) {
        let page  = UInt(sender.value)
        pageItem.title = "Стр. \(page + 1)"
        
        request.pageOffset = page
        fetchData()
    }
    
    @IBAction func onPageSizeChange(_ sender: UISegmentedControl) {
        var size = UINT32_MAX
        switch sender.selectedSegmentIndex {
        case 0:
            size = 3
            break
        case 1:
            size = 10
            break
        default:
            size = UINT32_MAX
        }
        
        request.fetchLimit = UInt(size)
        fetchData()
    }
    
    @IBAction func onFromDateToggle(_ sender: UISwitch) {
        let isOn = sender.isOn
        request.fromDate = isOn ? fromPicker.date : nil
        fromPicker.isHidden = !isOn
        
        fetchData()
    }
    
    @IBAction func onFromDateValueChange(_ sender: UIDatePicker) {
        if !fromSwitch.isOn { return }
        request.fromDate = sender.date
        fetchData()
    }
    
    @IBAction func onToDateToggle(_ sender: UISwitch) {
        let isOn = sender.isOn
        request.toDate = isOn ? toPicker.date : nil
        toPicker.isHidden = !isOn
        
        fetchData()
    }
    
    @IBAction func onToDateValueChange(_ sender: UIDatePicker) {
        if !toSwitch.isOn { return }
        request.toDate = sender.date
        fetchData()
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notifications[indexPath.row]
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        var body = "push-id: \(notification.identifier)"
        if let title = notification.title {
            body += " | title: \(title)"
        }
        if let text = notification.text {
            body += " | text: \(text)"
        }
        body += " | date: \(dateFormatter.string(from: notification.date))"
        
        if let url = notification.content?.url {
            body += " | url: \(url)"
        }
        if let customPayload = notification.customPayload as? NSObject {
            var payload = customPayload.description
            if payload.count > 50 {
                payload = String(payload.prefix(50))
            }
            body += " | customPayload: \(payload)"
        }
        cell.labelText = body
        
        if let contentType = notification.content?.type, contentType == .image, let url = notification.content?.url {
            cell.imageURL(url)
        }
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction.init(style: .destructive, title: "Удалить") { [weak self] action, _, completion in
            guard let self = self else { return }
            
            self.deleteObjectAtIndexPath(indexPath)
            completion(true)
        }
        return UISwipeActionsConfiguration.init(actions: [deleteAction])
    }
}
