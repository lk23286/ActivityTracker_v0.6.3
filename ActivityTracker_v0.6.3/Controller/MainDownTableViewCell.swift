//
//  MainDownTableViewCell.swift
//  ActivityTracker_v0.6.3
//
//  Created by Laszlo Kovacs on 2022. 08. 19..
//

import UIKit

class MainDownTableViewCell: UITableViewCell {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var achivedLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var precentLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
