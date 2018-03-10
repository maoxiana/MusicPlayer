//
//  pvMusicController.swift
//  player
//
//  Created by 毛线 on 2018/2/16.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import Foundation
import UIKit
let musicListView = MusicListViewController()
class pvMusicController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(playMusic))
        rightBarBtn.image = #imageLiteral(resourceName: "music")
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(list))
        leftBarBtn.image = #imageLiteral(resourceName: "find")
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.title = "发现"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Symbol", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    @objc func playMusic(){
        self.navigationController?.pushViewController(playView, animated: true)
        playView.tabBarController?.tabBar.isHidden = true
    }
    @objc func list(){
        self.navigationController?.pushViewController(musicListView, animated: true)
        musicListView.tabBarController?.tabBar.isHidden = true
    }
}

