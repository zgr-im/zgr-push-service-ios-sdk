//
//  SwitchTableViewCell.swift
//  Demo Push App
//
//  Created by alex on 13.04.2021.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    public var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    public var toggled: Bool {
        get { return switchView.isOn }
        set { switchView.isOn = newValue }
    }
    
    public var cellAction: ((Bool) -> ())?
    
    @IBAction func onToggle(_ sender: UISwitch) {
        if cellAction != nil {
            cellAction?(sender.isOn)
        }
    }
}
