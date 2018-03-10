//
//  pvActivityController.swift
//  player
//
//  Created by 毛线 on 2018/2/16.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
let playView = MusicViewController()
class pvActivityController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(playMusic))
        rightBarBtn.image = #imageLiteral(resourceName: "music")
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.title = "动态"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Symbol", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.black]
        
    }
    @objc func playMusic(){
        self.navigationController?.pushViewController(playView, animated: true)
        playView.tabBarController?.tabBar.isHidden = true
    }
}

