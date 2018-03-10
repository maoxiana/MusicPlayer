//
//  MusicViewController.swift
//  player
//
//  Created by 毛线 on 2018/3/5.
//  Copyright © 2018年 毛线. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class MusicViewController: UIViewController {
    let playbackSlider = UISlider()
    let playButton = UIButton()
    let backgroundImage = UIImageView()
    let songName = UILabel()
    let singer = UILabel()
    let playTime = UILabel()
    let totalTime = UILabel()
    let favorate = UIButton()
    let list = UIButton()
    let lastSong = UIButton()
    let nextSong = UIButton()
    let lyircScrollView = UIScrollView()
    var playerItem: AVPlayerItem!
    
    var timeLrc = [TimeInterval: String]()
    let heightOfLCRLabel = CGFloat(40)
    var lrcTimeArray = [TimeInterval]()
    var lrcLabelViewArray = [UILabel]()
    var isTimeToChangeScrollView = false
    var tempLRCTime:TimeInterval = 0
    var isShowLyirc = false
    var timer: Timer!
    
    var player: AVPlayer!
    var isfavorate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        backgroundImage.frame = CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 340)
        self.view.addSubview(backgroundImage)
        
        songName.frame = CGRect(x: 15, y: 400, width: 110, height: 40)
        songName.font = UIFont(name: "Symbol", size: 21)
        self.view.addSubview(songName)
        singer.frame = CGRect(x: 15, y: 450, width: 110, height: 30)
        self.view.addSubview(singer)
        
        playButton.frame = CGRect(x: 160, y: 580, width: 60, height: 60)
        playButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.view.addSubview(playButton)
        
        playbackSlider.frame = CGRect(x: 100, y: 520, width: 160, height: 30)
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
        playbackSlider.setThumbImage(#imageLiteral(resourceName: "slider"), for: .normal)
        self.view.addSubview(playbackSlider)
        
        playTime.frame = CGRect(x: 15, y: 525, width: 60, height: 20)
        playTime.text = "00:00"
        self.view.addSubview(playTime)
        totalTime.frame = CGRect(x: 300, y: 525, width: 60, height: 20)
        self.view.addSubview(totalTime)
        
        favorate.frame = CGRect(x: 315, y: 595, width: 30, height: 30)
        favorate.setImage(#imageLiteral(resourceName: "favorate"), for: .normal)
        favorate.addTarget(self, action: #selector(favoratetapped), for: .touchUpInside)
        self.view.addSubview(favorate)
        
        list.frame = CGRect(x: 30, y: 595, width: 30, height: 30)
        list.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        self.view.addSubview(list)
        
        lastSong.frame = CGRect(x: 90, y: 595, width: 30, height: 30)
        lastSong.setImage(#imageLiteral(resourceName: "last"), for: .normal)
        self.view.addSubview(lastSong)
        
        nextSong.frame = CGRect(x: 255, y: 595, width: 30, height: 30)
        nextSong.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        self.view.addSubview(nextSong)
        
        
        
        //导航栏
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToPrevious))
        leftBarBtn.image = #imageLiteral(resourceName: "back")
        self.navigationItem.leftBarButtonItem = leftBarBtn
        let rightBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToPrevious))
        rightBarBtn.image = #imageLiteral(resourceName: "more")
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        let musicUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "Green Light", ofType: "mp3")!)
        playerItem = AVPlayerItem(url: musicUrl)
        player = AVPlayer(playerItem: playerItem)
        
        //进度条
        
        playbackSlider.setThumbImage(#imageLiteral(resourceName: "slider"), for: .normal)
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = false
        totalTime.text=self.changTime(all: Int(seconds),  m: Int(seconds) % 60, f: Int(Int(seconds)/60))
        let metadataList = playerItem.asset.commonMetadata
        for item in metadataList {
            if item.commonKey!.rawValue == "title" {
                let songName = item.stringValue
                self.songName.text = songName
            }
            if item.commonKey!.rawValue == "albumName" {
                let singer = item.stringValue
                self.singer.text = singer
            }
            if item.commonKey!.rawValue == "artwork" {
                let image = UIImage(data: item.dataValue!)
                self.backgroundImage.image = image
            }
        }
        //播放过程中动态改变进度条值和时间标签
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1),
                                        queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay && self.player?.rate != 0{
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                self.playbackSlider.value = Float(currentTime)
                self.playTime.text = self.changTime(all: Int(currentTime), m: Int(currentTime) % 60, f: Int(Int(currentTime)/60))
            }
        }
        //滚动歌词
        lyircScrollView.frame = CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 340)
        let pathURLOfLRC = URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType: "lrc")!)
        let allContentOfLrc = try! NSString(contentsOf: pathURLOfLRC, encoding: String.Encoding.utf8.rawValue)
        var arrayOfLrc = allContentOfLrc.components(separatedBy: "\n")
        arrayOfLrc = arrayOfLrc.filter{ $0 != "" }
        //歌词内容存入字典
        for i in 0 ..< arrayOfLrc.count {
            var arrContentLrc = arrayOfLrc[i].components(separatedBy: "]")
            let number = "0123456789"
            if(number.components(separatedBy: (arrContentLrc[0] as NSString).substring(with: NSMakeRange(1, 1))).count > 1){
                for k in 0..<(arrContentLrc.count - 1) {
                    if arrContentLrc[k].contains("[") {
                        arrContentLrc[k] = (arrContentLrc[k] as NSString).substring(from: 1)
                    }
                    func calculatString2Time(strTime: NSString) -> TimeInterval {
                        var arrTime = strTime.components(separatedBy: ":") as [NSString]
                        let numberTime = arrTime[0].doubleValue * 60 + arrTime[1].doubleValue
                        return numberTime
                    }
                    timeLrc[calculatString2Time(strTime: arrContentLrc[k] as NSString)] = arrContentLrc[arrContentLrc.count - 1]
                }
            }
        }
        //scrollview的大小
        lyircScrollView.showsVerticalScrollIndicator = false
//        lyircScrollView.contentSize.width = self.view.frame.width
//        lyircScrollView.contentSize.height = self.view.frame.height * 0.65 + (heightOfLCRLabel * CGFloat(timeLrc.count))
        
        //显示歌词
        func showLRCToScrollView() {
            var i:CGFloat = 0
            for key in timeLrc.keys.sorted() {
                let label = UILabel(frame: CGRect(
                    x: 20,
                    y: (380 / 2 + (heightOfLCRLabel * i)),
                    width: self.view.frame.width-40,
                    height: heightOfLCRLabel))
                
                label.text = timeLrc[key]!
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor.lightGray
                label.textAlignment = NSTextAlignment.center
                label.font = UIFont.systemFont(ofSize: 16)
                lyircScrollView.addSubview(label)
                lrcLabelViewArray.append(label)
                lrcTimeArray.append(key)
                i += 1
            }
        }
//        lyircScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        showLRCToScrollView()
        self.view.addSubview(lyircScrollView)
        lyircScrollView.isHidden = true
        
        //点击背景出现歌词
        backgroundImage.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        backgroundImage.addGestureRecognizer(tapGR)
        lyircScrollView.isUserInteractionEnabled = true
        let tapGRt = UITapGestureRecognizer(target: self, action: #selector(tapScroll))
        lyircScrollView.addGestureRecognizer(tapGRt)
        

        //更新歌词
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateLRCScrollView), userInfo: nil, repeats: true)
        
    }
    func maxElementOfLrcTime() -> TimeInterval! {
        let currentTime = CMTimeGetSeconds(player!.currentTime())
        return lrcTimeArray.filter { $0 <= currentTime }.max()
    }
    
    @objc func updateLRCScrollView() {
        if lrcTimeArray.isEmpty {
            return
        }
        switch CMTimeGetSeconds(player!.currentTime()) {
        case 0..<lrcTimeArray[0]:
            isTimeToChangeScrollView = true
            return
        case lrcTimeArray[0]..<CMTimeGetSeconds(playerItem.asset.duration):
            if tempLRCTime != maxElementOfLrcTime()! {
                tempLRCTime = maxElementOfLrcTime()!
                isTimeToChangeScrollView = true
            } else {
                isTimeToChangeScrollView = false
            }
            //更新位置
            if isTimeToChangeScrollView {
                let lrcRowNumber = lrcTimeArray.index(of: tempLRCTime)!
                var newOffset = lyircScrollView.contentOffset
                
                newOffset.y = lrcLabelViewArray[lrcRowNumber].center.y - 340 / 2
                lyircScrollView.setContentOffset(newOffset, animated: true)
                
                for itemLabel in lrcLabelViewArray {
                    itemLabel.textColor = UIColor.lightGray
                    itemLabel.font = UIFont.systemFont(ofSize: 16)
                }
                
                // 高亮
                lrcLabelViewArray[lrcRowNumber].textColor = UIColor.gray
                lrcLabelViewArray[lrcRowNumber].font = UIFont.systemFont(ofSize: 20)
            }
        default:
            return
        }
    }
    
    func changTime(all: Int, m: Int, f: Int) -> String{
        var time:String=""
        if f<10{
            time="0\(f):"
        }else {
            time="\(f)"
        }
        if m<10{
            time+="0\(m)"
        }else {
            time+="\(m)"
        }
        return time
    }
    @objc func playButtonTapped(_ sender: UIButton) {
        if player?.rate == 0 {
            player!.play()
            playButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        } else {
            player!.pause()
            playButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            
        }
    }
    @objc func favoratetapped(_ sender: UIButton) {
        if isfavorate{
            favorate.setImage(#imageLiteral(resourceName: "favorate"), for: .normal)
            isfavorate = false
        }else{
            favorate.setImage(#imageLiteral(resourceName: "realfavorate"), for: .normal)
            isfavorate = true
            favorate.layer.setAffineTransform(CGAffineTransform(scaleX: 1,y: 1))
            //设置动画效果
            UIView.animate(withDuration: 0.65, delay:0, options:[], animations: {
                ()-> Void in
                self.favorate.layer.setAffineTransform(CGAffineTransform(scaleX: 1.5,y: 1.5))
            },
                           completion:{(finished:Bool) -> Void in
                            UIView.animate(withDuration: 0.65, animations:{()-> Void in
                                self.favorate.layer.setAffineTransform(CGAffineTransform.identity)
                            })
            })
        }
    }
    //拖动进度条
    @objc func playbackSliderValueChanged(_ sender: Any) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        backgroundImage.isHidden = false
        lyircScrollView.isHidden = true
    }
    @objc func tapImage(sender:UITapGestureRecognizer) {
        backgroundImage.isHidden = true
        lyircScrollView.isHidden = false
    }
    @objc func tapScroll(sender:UITapGestureRecognizer) {
        backgroundImage.isHidden = false
        lyircScrollView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


