//
//  MusicTableViewCell.swift
//  player
//
//  Created by 毛线 on 2018/3/9.
//  Copyright © 2018年 毛线. All rights reserved.
//

import UIKit
import SnapKit
class MusicTableViewCell: UITableViewCell {
    var nameLabel = UILabel()
    var artistLabel = UILabel()
    var rightImage = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.accessoryType = .none
        nameLabel.textAlignment = .left
        artistLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        artistLabel.font = UIFont.systemFont(ofSize: 16)
        artistLabel.textColor = UIColor.lightGray
        rightImage.image = #imageLiteral(resourceName: "more")
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(10)
        }
        contentView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-10)
        }
        contentView.addSubview(rightImage)
        rightImage.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell(name: String, artist: String) {
        nameLabel.text = name
        artistLabel.text = artist
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

