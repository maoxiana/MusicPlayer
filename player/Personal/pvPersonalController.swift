//
//  pvPersonalController.swift
//  player
//
//  Created by 毛线 on 2018/2/16.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
let bgHeight = CGFloat(250)
let vc = LoadingViewController()
var isLoad = false
let labelWidth = UIScreen.main.bounds.width / 3
class pvPersonalController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    var tableView = UITableView()
    var dataArray = [[String]]()
    var picArray = [[String]]()
    let userImageView = UIImageView(frame: CGRect(x: 30, y: 70, width: 80, height: 80))
    let userNameLabel = UILabel(frame: CGRect(x: 100, y: 110, width: 150, height: 40))
    let bgimageView = UIImageView(image:UIImage(named:"bgimage"))
    let loadButtontwo:UIButton = UIButton(type:.custom)
    let followsLabel = UILabel(frame: CGRect(x: 0, y: 175, width: labelWidth, height: 75))
    let followedLabel = UILabel(frame: CGRect(x: labelWidth, y: 175, width: labelWidth, height: 75))
    let authorityLabel = UILabel(frame: CGRect(x: labelWidth * 2, y: 175, width: labelWidth, height: 75))
    let loadFinish = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: bgHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.navigationBar.isTranslucent = true
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()

        //登录后
        userImageView.layer.cornerRadius = 40
        userImageView.clipsToBounds = true
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = UIColor.lightGray
        userNameLabel.font = UIFont.systemFont(ofSize: 18)
        loadFinish.addSubview(userImageView)
        loadFinish.addSubview(userNameLabel)
        //登录后分栏
        let labels = [followsLabel, followedLabel, authorityLabel]
        for i in labels{
            i.numberOfLines = 3
            i.textAlignment = .center
            i.textColor = UIColor.black
            i.font = UIFont.systemFont(ofSize: 19)
            i.layer.borderColor = lightGray.cgColor
            i.layer.borderWidth = 2
            loadFinish.addSubview(i)
        }

        self.view.addSubview(loadFinish)

        //登录框
        bgimageView.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width:UIScreen.main.bounds.width, height:bgHeight))
        
        
        loadButtontwo.frame = CGRect(x:(UIScreen.main.bounds.width - loadWidth)/2, y:(bgHeight - loadHeight)/2, width:loadWidth, height:loadHeight)
        loadButtontwo.setTitle("立即登录", for:.normal)
        loadButtontwo.backgroundColor = pinkColor
        loadButtontwo.layer.borderColor = UIColor.white.cgColor
        loadButtontwo.layer.cornerRadius = 8
        loadButtontwo.addTarget(self, action:#selector(toLoad), for:.touchUpInside)
       

        //界面
//        if isLoad == false{
//            self.view.addSubview(bgimageView)
//            self.view.addSubview(loadButtontwo)
//        }else{
//            self.view.addSubview(userImageView)
//        }
        
        //列表
        self.dataArray = [["本地音乐", "我的收藏"], ["申请", "定时关闭", "设置", "关于"]]
        self.picArray = [["download", "favirate"], ["plus", "time", "set up", "about"]]
        self.tableView = UITableView(frame: CGRect(x:0,y:bgHeight, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height - loadHeight), style: .grouped)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cells")
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        //设置分割线颜色
        self.tableView.separatorColor = lightGray
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.dataArray[section]
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cells")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cells")
            }

            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
            cell?.imageView?.image = UIImage(named: picArray[indexPath.section][indexPath.row])
            cell?.selectionStyle = .none
            cell?.accessoryType = .none
            return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57.0
    }
    
    //组头
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = lightGray
        return headerView
    }
    //组尾
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = lightGray
        return footerView
    }
    //    设置分组尾的高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    @objc func toLoad(){
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        if isLoad == false{
            loadFinish.isHidden = true
            self.view.addSubview(bgimageView)
            self.view.addSubview(loadButtontwo)
        }else{
            bgimageView.isHidden = true
            loadButtontwo.isHidden = true
            userImageView.sd_setImage(with: URL(string: userImageUrl))
            userNameLabel.text = userName
            followsLabel.text = "我的关注\n4"
//            (userProfile["follows"] as! String)
            followedLabel.text = "我的粉丝\n0"
//                (userProfile["followeds"] as! String)
            authorityLabel.text = "我的作品\n" + String(describing: userProfile["authority"]!)
            loadFinish.isHidden = false
        }
    }
}

