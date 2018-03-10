//
//  LoadingView.swift
//  player
//
//  Created by 毛线 on 2018/2/20.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
var userImageUrl = ""
var userName = ""
var userDict = Dictionary<String,AnyObject>()
var userProfile = Dictionary<String,AnyObject>()
var userId: String?
class LoadingViewController: UIViewController{

    
    let loadText = UITextField(frame: CGRect(x:0, y:200, width:UIScreen.main.bounds.width, height:50))
    let passText = UITextField(frame: CGRect(x:0, y:252, width:UIScreen.main.bounds.width, height:50))
    let errorLabel = UILabel(frame:CGRect(x:(UIScreen.main.bounds.width - 200)/2, y: 232, width: 200, height: loadHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lightGray
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "登录"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Symbol", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.black]
        
        loadText.placeholder = "  请输入手机号"
        loadText.minimumFontSize = 11
        loadText.backgroundColor = UIColor.white
        loadText.layer.borderColor = UIColor.lightGray.cgColor
        loadText.clearButtonMode = .whileEditing
        
        passText.placeholder = "  请输入密码"
        passText.isSecureTextEntry = true
        passText.backgroundColor = UIColor.white
        passText.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(passText)
        self.view.addSubview(loadText)
        passText.clearButtonMode = .whileEditing
        
        //loadBtn
        let loadBtn = UIButton()
        loadBtn.frame = CGRect(x:(UIScreen.main.bounds.width - 300)/2, y:330, width:300, height:loadHeight)
        loadBtn.setTitle("登录", for:.normal)
        loadBtn.backgroundColor = pinkColor
        loadBtn.layer.borderColor = UIColor.white.cgColor
        loadBtn.layer.cornerRadius = 8
        self.view.addSubview(loadBtn)
        
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToPrevious))
        leftBarBtn.image = #imageLiteral(resourceName: "back")
        let rightBtn = UIBarButtonItem(title: "注册", style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        //登录错误提示
        
        errorLabel.backgroundColor = UIColor.lightGray
        errorLabel.textColor = UIColor.white
        errorLabel.text = "用户名或密码错误"
        errorLabel.textAlignment = .center
        self.view.addSubview(errorLabel)
        errorLabel.isHidden = true
        
        loadBtn.addTarget(self, action:#selector(tryToLoad), for:.touchUpInside)
    }
    @objc func tryToLoad(){
        let name = loadText.text
        let pass = passText.text
        if name == nil || pass == nil{
            return
        }else{
            let url = "http://localhost:3000/login/cellphone?phone=" + name! + "&password=" + pass!
            Alamofire.request(url ,method: .get)
                .responseJSON { response in
                guard let json = response.result.value else {
                    self.errorLabel.isHidden = false
                    _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.miss), userInfo: nil, repeats: false)
                    return
                    }
                let dict = json as! Dictionary<String,AnyObject>
                let data = dict["account"] as! Dictionary<String,AnyObject>
                userId = String(describing: (data["id"]!))
                userProfile = dict["profile"] as! Dictionary<String,AnyObject>
                userImageUrl = userProfile["avatarUrl"] as! String
                userName = userProfile["nickname"] as! String
                self.backToPrevious()
            }
            isLoad = true
            
        }
    }
    @objc func miss(){
        errorLabel.isHidden = true
    }
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
}
func getIntFromString(str:String) -> String {
    let scanner = Scanner(string: str)
    scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
    var number :Int = 0
    
    scanner.scanInt(&number)
    return String(number)
    
}
