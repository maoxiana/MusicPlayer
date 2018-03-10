//
//  PageViewController.swift
//  player
//
//  Created by 毛线 on 2018/2/15.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
let pinkColor = UIColor.init(red: 255/255.0, green: 18/255.0, blue: 80/255.0, alpha: 1)
let lightGray = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
class PageViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()

        //首页导航控制器
        let pvMusic = pvMusicController()
        let navMusic = UINavigationController(rootViewController: pvMusic)
        navMusic.title = "发现"
        navMusic.tabBarItem.image = #imageLiteral(resourceName: "search")
//        navMusic.tabBarItem.selectedImage = #imageLiteral(resourceName: "search2")
        //动态信息导航栏
        let pvActivity = pvActivityController()
        let navActivity = UINavigationController(rootViewController: pvActivity)
        navActivity.title="动态"
        navActivity.tabBarItem.image = #imageLiteral(resourceName: "news")
//        navActivity.tabBarItem.selectedImage = #imageLiteral(resourceName: "news2")
        //消息导航栏
        let pvMessage = pvMessageController()
        let navMessage = UINavigationController(rootViewController: pvMessage)
        navMessage.title="信息"
        navMessage.tabBarItem.image = #imageLiteral(resourceName: "message")
//        navMessage.tabBarItem.selectedImage = #imageLiteral(resourceName: "message2")
        //个人中心导航栏
        let pvPersonal = pvPersonalController()
        let navPersonal = UINavigationController(rootViewController: pvPersonal)
        navPersonal.title="我的"
        navPersonal.tabBarItem.image = #imageLiteral(resourceName: "my")
//        navPersonal.tabBarItem.selectedImage = #imageLiteral(resourceName: "my2")
        //添加工具栏
        let items = [navMusic,navActivity,navMessage,navPersonal]
        self.viewControllers = items
        //自定义工具栏
        self.tabBar.tintColor = pinkColor
        self.tabBar.barTintColor = UIColor.white
        for i in self.viewControllers!{
            let rightBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(playMusic))
            rightBarBtn.image = #imageLiteral(resourceName: "music")
            i.navigationItem.rightBarButtonItem = rightBarBtn
            i.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        }
    }
    @objc func playMusic(){
        navigationController?.pushViewController(playView, animated: true)
        playView.tabBarController?.tabBar.isHidden = true
    }
}

















