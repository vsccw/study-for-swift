//
//  TaskCell.swift
//  new-user-notifications
//
//  Created by 程庆春 on 2017/1/2.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleReminderMeButton: UIButton!

    var onButtonSelection: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func remindMeButtonTapped(_ sender: Any) {
        onButtonSelection?()
    }

    func showReminderOnIcon() {
        toggleReminderMeButton.setTitle("🔊", for: .normal)
    }
    func showReminderOffIcon() {
        toggleReminderMeButton.setTitle("🔇", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
