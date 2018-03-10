//
//  pvMessageController.swift
//  player
//
//  Created by 毛线 on 2018/2/15.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
let loadWidth = CGFloat(120)
let loadHeight = CGFloat(40)
class pvMessageController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let loadbgView = UIImageView(image:UIImage(named:"loadbg"))
        loadbgView.frame = CGRect(x:(UIScreen.main.bounds.width - 300)/2, y:(UIScreen.main.bounds.height - 260)/2, width:300, height:260)
        
        
        
        let loadButton:UIButton = UIButton(type:.custom)
        loadButton.frame = CGRect(x:(UIScreen.main.bounds.width - loadWidth)/2, y:(UIScreen.main.bounds.height - loadHeight)/2, width:loadWidth, height:loadHeight)
        loadButton.setTitle("立即登录", for:.normal)
        loadButton.backgroundColor = pinkColor
        loadButton.layer.borderColor = UIColor.white.cgColor
        loadButton.layer.cornerRadius = 8
        
        if isLoad == false{
            self.view.addSubview(loadbgView)
            self.view.addSubview(loadButton)
        }
        loadButton.addTarget(self, action:#selector(toLoadt), for:.touchUpInside)
        
    }
    @objc func toLoadt(){
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = false
    }
}
