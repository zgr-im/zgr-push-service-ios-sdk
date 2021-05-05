//
//  DetailTableViewCell.swift
//  Demo Push App
//
//  Created by alex on 14.04.2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    public var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    public var value: String {
        get { return detailLabel.text ?? "" }
        set { detailLabel.text = newValue }
    }
}
