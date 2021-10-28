//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Apple on 10/28/21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    ///@IBOutlet
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var forcastImageView: UIImageView!
    @IBOutlet weak var tempratureFLabel: UILabel!
    @IBOutlet weak var tempratureCLabel: UILabel!
    @IBOutlet weak var viewContent: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
