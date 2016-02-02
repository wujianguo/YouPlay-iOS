//
//  PlayerViewController.swift
//  YouPlay-iOS
//
//  Created by wujianguo on 16/1/10.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

private let YouParseApi = "https://youplay.leanapp.cn/api/v1"

class PlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.drawable = playerView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyPlayerStateChanged:", name: VLCMediaPlayerStateChanged, object: nil)
        NSTimer.scheduledTimerWithTimeInterval(60*20, target: self, selector: "handleUpdateSteamUrlTimer:", userInfo: nil, repeats: true)
        startPlay()
    }
    
    var items: YouPlaySource!
    var startIndex = 0
    
    func startPlay() {
        if startIndex >= items.urls.count {
            return
        }
        queryStreamUrls(items.urls[startIndex]) { (us) -> Void in
            self.urls = us
            self.playNext()
        }
    }
    
    func playNext() {
        if index >= urls.count {
            index = 0
            startIndex += 1
            startPlay()
        }
        player.setMedia(VLCMedia(URL: NSURL(string: urls[index])))
        player.play()
        index += 1
    }
    
    func handleUpdateSteamUrlTimer(timer: NSTimer) {
        print("timer")
        queryStreamUrls(items.urls[startIndex]) { (us) -> Void in
            self.urls = us
        }
    }
    
    func notifyPlayerStateChanged(notification: NSNotification) {
        print("notifyPlayerStateChanged: \(VLCMediaPlayerStateToString(player.state()))")
        if player.state() == VLCMediaPlayerStateEnded {
            playNext()
        }
    }
    
    
    @IBOutlet weak var playerView: UIView!
    
    let player = VLCMediaPlayer()
    var urls = [String]()
    var index = 0

    @IBAction func closeButtonClick(sender: UIButton) {
        player.stop()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
