//
//  CustomHeaderView.swift
//  TableView
//
//  Created by 김주협 on 2021/05/09.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    
    // Outlet을 먼저 코드로 작성한다음 Connection Well을 드래그하여 연결함
    // 기존 방식대로 opt + Drag 하면 Object가 안맞아서 에러남
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countLabel.text = "0"
        countLabel.layer.cornerRadius = 30
        countLabel.clipsToBounds = true
        
        backgroundView = customBackgroundView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

