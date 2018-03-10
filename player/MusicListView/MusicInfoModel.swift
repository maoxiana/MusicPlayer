//
//  File.swift
//  player
//
//  Created by 毛线 on 2018/3/9.
//  Copyright © 2018年 毛线. All rights reserved.
//

import Foundation
class MusicInfo{
    var name = ""
    var artist = ""
    var picUrl = ""
    var musicUrl = ""
    var lyric = ""
    init(name: String, artist: String, picUrl: String, musicUrl: String, lyric: String) {
        self.name = name
        self.artist = artist
        self.picUrl = picUrl
        self.musicUrl = musicUrl
        self.lyric = lyric
    }
}
