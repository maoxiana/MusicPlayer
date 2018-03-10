//
//  newCell.swift
//  player
//
//  Created by 毛线 on 2018/2/19.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class newCell: UITableViewCell {
    var subjectLabel = UILabel()
    var picView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        subjectLabel.textAlignment = .left
        subjectLabel.numberOfLines = 0
        subjectLabel.font = UIFont.italicSystemFont(ofSize:20)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(picView)
        
        picView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView.snp.left).offset(10)
//            make.height.equalTo(contentView).multipliedBy(0.8)
//            make.width.equalTo(contentView).multipliedBy(0.25)
        }
        
        subjectLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(picView.snp.right).offset(10)
            //            make.top.equalTo(contentView).offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func initCell(subject: String, pic: String) {
        subjectLabel.text = subject
        picView.image = UIImage(named:pic)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

