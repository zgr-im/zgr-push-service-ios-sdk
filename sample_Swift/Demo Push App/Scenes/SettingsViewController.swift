//
//  SettingsViewController.swift
//  Demo Push App
//
//  Created by alex on 16.04.2021.
//

import UIKit
import ZGRImSDK

public enum SectionType: Int {
    case common
    case subscriptions
    case config
}

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var installation: ZGRInstallation?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        fetchData()
    }
    
    // MARK: - Data
    func reloadData() {
        tableView.reloadData()
    }
    
    func fetchData() {
        ZGRMessaging.sharedInstance().fetchInstallation() { [weak self] installation, error in
            guard let self = self else { return }
            
            self.installation = installation
            DispatchQueue.main.async { self.reloadData() }
        }
    }
    
    // MARK: - Actions
    @IBAction func onDoneTap(_ sender: Any) {
        guard let installation = installation else { return }
        ZGRMessaging.sharedInstance().save(installation) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async { self.dismiss(animated: true) }
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.common.rawValue, SectionType.config.rawValue: return 3
        case SectionType.subscriptions.rawValue: return installation?.subscriptions.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.common.rawValue:           return "Общие"
        case SectionType.subscriptions.rawValue:    return "Подписки"
        case SectionType.config.rawValue:           return "Конфиг"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch indexPath.section {
        case SectionType.common.rawValue:           return cellForInstallationSection(tableView, atRow: row)
        case SectionType.subscriptions.rawValue:    return cellForSubscriptionsSection(tableView, atRow: row)
        case SectionType.config.rawValue:           return cellForConfigSection(tableView, atRow: row)
        default: return UITableViewCell()
        }
    }
}

private extension SettingsViewController {
    func cellForInstallationSection(_ tableView: UITableView, atRow row: Int) -> UITableViewCell {
        
        guard let installation = installation,
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as? DetailTableViewCell,
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as? SwitchTableViewCell
        else {
            return UITableViewCell()
        }
        
        switch row {
        case 0: // Primary device
            switchCell.title = "Основное устройство"
            switchCell.toggled = installation.isPrimary
            switchCell.cellAction = { toggled in
                installation.isPrimary = toggled
            }
            return switchCell
        case 1: // Push (App) enabled
            switchCell.title = "Разрешить уведомления"
            switchCell.toggled = installation.isPushEnabled
            switchCell.cellAction = { toggled in
                installation.isPushEnabled = toggled
            }
            return switchCell
        case 2: // Push (OS) enabled
            detailCell.title = "Показ уведомлений системой"
            detailCell.value = installation.isPushOsEnabled ? "Да" : "Нет"
            return detailCell
        default:
            return UITableViewCell()
        }
    }
    
    func cellForSubscriptionsSection(_ tableView: UITableView, atRow row: Int) -> UITableViewCell {
        
        guard let subscription = installation?.subscriptions[row],
            let textCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell,
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as? SwitchTableViewCell
        else {
            return UITableViewCell()
        }
        
        switch subscription.type {
        case .setting:
            textCell.title = subscription.title
            textCell.value = subscription.value
            textCell.cellAction = { value in
                subscription.setValueWith(value)
            }
            return textCell
        case .permission:
            switchCell.title = subscription.title
            switchCell.toggled = subscription.value == "true" ? true : false
            switchCell.cellAction = { toggled in
                subscription.setValueWith(toggled)
            }
            return switchCell
        default:
            return UITableViewCell()
        }
    }
    
    func cellForConfigSection(_ tableView: UITableView, atRow row: Int) -> UITableViewCell {
        
        guard let config = ZGRMessaging.sharedInstance().config,
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell
        else {
            return UITableViewCell()
        }
        
        switch row {
        case 0:
            cell.title = "Application id"
            cell.value = config.applicationId
            cell.cellAction = { value in
                config.applicationId = value
            }
            return cell
        case 1:
            cell.title = "Api key"
            cell.value = config.apiKey
            cell.cellAction = { value in
                config.apiKey = value
            }
            return cell
        case 2:
            cell.title = "Endpoint"
            cell.value = config.endpoint.absoluteString
            cell.cellAction = { value in
                config.endpoint = URL(string: value)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

