//
//  HistoryTableViewCell.swift
//  Demo Push App
//
//  Created by alex on 14.04.2021.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    public var labelText: String {
        get { return bodyLabel.text ?? "" }
        set { bodyLabel.text = newValue }
    }
    
    func imageURL(_ imageURL: URL) {
        let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
            if error == nil {
                DispatchQueue.main.async {
                    guard let self = self, let data = data else { return }
                    self.iconView.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
    }
}
