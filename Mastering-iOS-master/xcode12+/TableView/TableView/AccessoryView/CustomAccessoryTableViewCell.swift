//
//  CustomAccessoryTableViewCell.swift
//  TableView
//
//  Created by 김주협 on 2021/05/09.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//


// cellForRowat 에서 만들면 오버헤드가 발생하기 때문에 초기화 시점에 한번만 구현되도록 만든다.

import UIKit

class CustomAccessoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let v = UIImageView(image: UIImage(systemName: "star"))
        accessoryView = v
//        accessoryType
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
