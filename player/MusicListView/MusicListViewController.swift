//
//  MusicListViewController.swift
//  player
//
//  Created by 毛线 on 2018/3/8.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SnapKit
var musicList: [MusicInfo] = []
class MusicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView?
    let playAllButton = UIButton()
    let playImage = UIImageView()
    let playLabel = UILabel()
    var cellHeight: CGFloat?
    override func viewDidLoad() {
        loadDataSource()
        let height = self.navigationController?.navigationBar.frame.maxY
        self.cellHeight = (UIScreen.main.bounds.height - height!) / 9
        playAllButton.frame = CGRect(x: 0, y: height!, width: UIScreen.main.bounds.width, height: cellHeight!)
        self.tableView = UITableView(frame: CGRect(x: 0, y: playAllButton.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - playAllButton.frame.maxY), style: .plain)
        self.tableView?.register(MusicTableViewCell.self, forCellReuseIdentifier: "musicCell")
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView?.separatorColor = lightGray
        self.view.addSubview(tableView!)
        playLabel.text = "播放全部"
        playLabel.textColor = UIColor.black
        playLabel.font = UIFont.systemFont(ofSize: 18)
        playAllButton.backgroundColor = UIColor.white
        playAllButton.layer.borderWidth = 1
        playAllButton.layer.borderColor = lightGray.cgColor
        self.view.addSubview(playAllButton)
        playAllButton.addSubview(playLabel)
        playImage.image = #imageLiteral(resourceName: "stop")
        playAllButton.addSubview(playImage)
        
        //playBtn布局
        playImage.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(playAllButton).offset(20)
            make.centerY.equalTo(playAllButton.snp.centerY)
            make.height.equalTo(playAllButton.snp.height).multipliedBy(0.4)
            make.width.equalTo(playAllButton.snp.height).multipliedBy(0.4)
        }
        playLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(playImage.snp.right).offset(10)
            make.centerY.equalTo(playAllButton.snp.centerY)
        }
        
        //导航栏
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToPrevious))
        leftBarBtn.image = #imageLiteral(resourceName: "back")
        let rightBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(playMusic))
        rightBtn.image = #imageLiteral(resourceName: "music")
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? MusicTableViewCell
        if cell == nil{
            tableView.register(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "musicCell")
            cell = (tableView.dequeueReusableCell(withIdentifier: "musicCell") as? MusicTableViewCell)!
        }
        cell?.initCell(name: musicList[indexPath.row].name, artist: musicList[indexPath.row].artist)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight!
    }
    
    
    func loadDataSource(){
        var musicInfo: MusicInfo?
        let url = "http://localhost:3000/user/playlist?uid=" + (userId ?? "1392322378")
        Alamofire.request(url ,method: .get)
            .responseJSON { response in
                guard let playListInfo = response.result.value else{return}
                let playListDict = playListInfo as! Dictionary<String,AnyObject>
                let playList = playListDict["playlist"] as! [Dictionary<String,AnyObject>]
                let listId = String(describing: (playList[0]["id"]!))
                let listDetailUrl = "http://localhost:3000/playlist/detail?id=" + listId
                Alamofire.request(listDetailUrl ,method: .get)
                    .responseJSON { response in
                        guard let listDetailInfo = response.result.value else{return}
                        let listDetailDict = listDetailInfo as! Dictionary<String,AnyObject>
                        let listDetailResult = listDetailDict["result"] as! Dictionary<String,AnyObject>
                        let listDetailTracks = listDetailResult["tracks"] as!
                            [Dictionary<String,AnyObject>]
                        for music in listDetailTracks{
                            let name = music["name"] as! String
                            let id = String(describing: (music["id"])!)
                            let artistInfo = music["artists"] as! [Dictionary<String,AnyObject>]
                            var artist = ""
                            for name in artistInfo{
                                artist += (name["name"] as! String) + ""
                            }
                            let picUrl = artistInfo[0]["picUrl"] as! String
                            var lyric = ""
                            let lyricUrl = "http://localhost:3000/lyric?id=" + id
                            Alamofire.request(lyricUrl ,method: .get)
                                .responseJSON { response in
                                    guard let lyricJson = response.result.value else{return}
                                    let lyricInfo = lyricJson as! Dictionary<String,AnyObject>
                                    let Irc = lyricInfo["lrc"] as! Dictionary<String,AnyObject>
                                    lyric = Irc["lyric"] as! String
                            }
                            let musicUrl = "http://music.163.com/song/media/outer/url?id=\(id).mp3"
                            musicInfo = MusicInfo(name: name, artist: artist, picUrl: picUrl, musicUrl: musicUrl, lyric: lyric)
                            musicList.append(musicInfo!)
                            self.tableView?.reloadData()
                        }
                }
        }
    }
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func playMusic(){
        self.navigationController?.pushViewController(playView, animated: true)
        playView.tabBarController?.tabBar.isHidden = true
    }
    
}
