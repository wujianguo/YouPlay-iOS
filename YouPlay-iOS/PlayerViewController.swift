//
//  PlayerViewController.swift
//  YouPlay-iOS
//
//  Created by wujianguo on 16/1/10.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit


class PlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.drawable = playerView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyPlayerStateChanged:", name: VLCMediaPlayerStateChanged, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyPlayerTimeChanged:", name: VLCMediaPlayerTimeChanged, object: nil)
        NSTimer.scheduledTimerWithTimeInterval(60*20, target: self, selector: "handleUpdateSteamUrlTimer:", userInfo: nil, repeats: true)
        startPlay()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: VLCMediaPlayerStateChanged, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: VLCMediaPlayerTimeChanged, object: nil)
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
            return
        }
        print("play \(index)")
        player.setMedia(VLCMedia(URL: NSURL(string: urls[index])))
        player.play()
        index += 1
    }
    
    func handleUpdateSteamUrlTimer(timer: NSTimer) {
        queryStreamUrls(items.urls[startIndex]) { (us) -> Void in
            self.urls = us
        }
    }
    
    func notifyPlayerStateChanged(notification: NSNotification) {
        print("notifyPlayerStateChanged: \(VLCMediaPlayerStateToString(player.state()))")
        if player.state() == VLCMediaPlayerStateStopped {
            playNext()
        }
    }
    
    func notifyPlayerTimeChanged(notification: NSNotification) {
        beginTimeLabel.text = "\(player.time())"
        guard !dragging else { return }
        if player.remainingTime.numberValue != nil && player.time().numberValue != nil {
            let duration = VLCTime(number: NSNumber(float: (player.time().numberValue.floatValue - player.remainingTime.numberValue.floatValue)))
            endTimeLabel.text = "\(duration)"
            timeSlider.maximumValue = duration.numberValue.floatValue
            timeSlider.setValue(player.time().numberValue.floatValue, animated: true)
        }
    }
    
    var dragging = false
    @IBAction func sliderTouchDown(sender: UISlider) {
        dragging = true
    }
    
    @IBAction func sliderTouchUpInside(sender: UISlider) {
        dragging = false
        player.setTime(VLCTime(number: NSNumber(float: sender.value)))
    }

    @IBAction func sliderTouchUpOutside(sender: UISlider) {
        dragging = false
        player.setTime(VLCTime(number: NSNumber(float: sender.value)))
    }
    
    
    @IBOutlet weak var beginTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
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
