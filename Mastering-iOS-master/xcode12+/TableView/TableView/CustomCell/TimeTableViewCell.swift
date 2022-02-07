//
//  TimeTableViewCell.swift
//  TableView
//
//  Created by 김주협 on 2021/05/09.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//

// CustomCell #2  반복적으로 사용할 수 있는 테이블 뷰 셀을 구현

import UIKit

class TimeTableViewCell: UITableViewCell {
// locationLabel ampmLabel timeLabel
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
