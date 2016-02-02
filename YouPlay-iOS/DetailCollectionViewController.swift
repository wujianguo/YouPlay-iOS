//
//  DetailCollectionViewController.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/5.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit
import AVKit
import AVFoundation

class PlayRecord {
    
}

@IBDesignable
class PlayButton: UIButton {
    
    @IBInspectable
    var themeColor: UIColor = UIColor.themeColor() { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, themeColor.CGColor)
        CGContextAddEllipseInRect(context, rect)
        CGContextFillPath(context)
        
        let radius = min(rect.height, rect.width) / 2 * 5 / 9
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, rect.width / 2 - radius / 2, rect.height / 2 - radius * sqrt(3) / 2)
        CGContextAddLineToPoint(context, rect.width / 2 - radius / 2, rect.height / 2 + radius * sqrt(3) / 2)
        CGContextAddLineToPoint(context, rect.width / 2 + radius, rect.height / 2)
        CGContextClosePath(context)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillPath(context);
    }
}

class SourceButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustsImageWhenHighlighted = false
        imageView?.contentMode = .Center
        titleLabel?.textAlignment = .Center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        if let image = imageForState(.Normal) {
            let imageW = image.size.width
            let imageH = image.size.height
            let imageX = contentRect.size.width - imageW - 10
            let imageY = (contentRect.size.height - imageH) / 2
            return CGRectMake(imageX, imageY, imageW, imageH)
        }
        return super.imageRectForContentRect(contentRect)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        if let _ = imageForState(.Normal) {
            let titleW = contentRect.size.width - 12 - 12;
            let titleH = self.frame.size.height;
            return CGRectMake(12, 0, titleW, titleH);
        }
        return super.titleRectForContentRect(contentRect)
    }
}


class DetailCollectionHeaderCell: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlayButton()
        setupSourceButton()
        setup()
    }
    
    weak var delegate: DetailCollectionHeaderDelegate?

    var thumbImage = UIImageView()
    var nameLabel = UILabel()
    var statusLabel = UILabel()
    var rationgLabel = UILabel()
//    var actors = UILabel()
    var year = UILabel()

    func setup() {
        
        nameLabel.textColor = UIColor.whiteColor()
        statusLabel.textColor = UIColor.whiteColor()
        rationgLabel.textColor = UIColor.whiteColor()
//        actors.textColor = UIColor.whiteColor()
        year.textColor = UIColor.whiteColor()
        
        nameLabel.font = UIFont.systemFontOfSize(15)
        statusLabel.font = UIFont.systemFontOfSize(12)
        rationgLabel.font = UIFont.systemFontOfSize(12)
//        actors.font = UIFont.systemFontOfSize(12)
        year.font = UIFont.systemFontOfSize(12)
        
        nameLabel.numberOfLines = 0
        
        addSubview(thumbImage)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(rationgLabel)
//        addSubview(actors)
        addSubview(year)
        
        thumbImage.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.equalTo(thumbImage.snp_height).multipliedBy(1.0/1.5)
        }
        
        playButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(thumbImage.snp_bottom)
            make.left.equalTo(thumbImage.snp_right).offset(18)
            make.width.equalTo(32)
            make.height.equalTo(playButton.snp_width)
        }
        
        sourceButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(playButton.snp_bottom)
            make.left.equalTo(playButton.snp_right).offset(35)
            make.width.equalTo(80)
            make.height.equalTo(playButton)
        }
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(thumbImage.snp_right).offset(18)
            make.top.equalTo(thumbImage).offset(8)
            make.right.equalTo(self).offset(-8)
            make.height.greaterThanOrEqualTo(50)
        }
        
        rationgLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(nameLabel)
            make.bottom.equalTo(playButton.snp_top).offset(-12)
        }
        
        year.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(nameLabel)
            make.bottom.lessThanOrEqualTo(rationgLabel.snp_top).offset(-12)
        }
        
        statusLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(nameLabel)
            make.bottom.lessThanOrEqualTo(year.snp_top).offset(-12)
        }
    }
    
    var sourceButton = SourceButton(frame: CGRectZero)
    var playButton = PlayButton(frame: CGRectZero)
    
    func setupPlayButton() {
        addSubview(playButton)
        
        playButton.addTarget(self, action: "playButtonClick:", forControlEvents: .TouchUpInside)
    }
    
    func playButtonClick(sender: UIButton) {
        delegate?.detailHeaderPlayButtonClick()
    }


    func setupSourceButton() {
        addSubview(sourceButton)
        sourceButton.setImage(UIImage(named: "triangle"), forState: .Normal)
        sourceButton.layer.masksToBounds = true
        sourceButton.layer.borderWidth = 1
        sourceButton.layer.cornerRadius = 16
        sourceButton.layer.borderColor = UIColor.themeColor().CGColor
        sourceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sourceButton.backgroundColor = UIColor.themeColor()
        sourceButton.tintColor = UIColor.whiteColor()
        sourceButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        sourceButton.titleLabel?.textAlignment = .Center
        
        sourceButton.addTarget(self, action: "sourceButtonClick:", forControlEvents: .TouchUpInside)
    }
    
    func sourceButtonClick(sender: UIButton) {
        delegate?.detailHeaderSourceButtonClick()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let image = thumbImage.image {
            let b = bounds
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
                let color = image.darkEffectColor(b)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.backgroundColor = color
                }
            }
        }
        
    }

}


protocol DetailCollectionHeaderDelegate: class {
    func detailHeaderSourceButtonClick()
    func detailHeaderPlayButtonClick()
}


class DetailItemCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    var titleLabel = UILabel()
    func setup() {
        contentView.backgroundColor = UIColor.themeColor()
        titleLabel.textAlignment = .Center
//        titleLabel.textColor = UIColor(rgb: 0x666666)
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
    }
    
    var thumb = ""
    
    override var selected: Bool {
        didSet {
            if selected {
                let b = contentView.bounds
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
                    guard self.selected else { return }
                    UIImageView.requestImageWithUrlString(self.thumb) { (image) -> Void in
                        guard self.selected else { return }
                        let color = image.darkEffectColor(b)
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            guard self.selected else { return }
                            self.contentView.backgroundColor = color
                            self.titleLabel.textColor = UIColor.whiteColor()
                        }
                    }
                }
            } else {
                contentView.backgroundColor = UIColor.themeColor()
                titleLabel.textColor = UIColor.blackColor()
            }
        }
    }
    
}

class DetailCollectionViewController: UICollectionViewController, DetailCollectionHeaderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        queryDetail(detailApi) { (d) -> Void in
            self.detail = d
            self.collectionView?.reloadData()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setBackgroundLightEffect(thumb)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }


    // MARK: UICollectionViewDataSource

    var curSource = 0
    var curIndex = 0
    var detailApi = ""
    var detail: YouPlayDetail?
    var playRecord: PlayRecord?
    var thumb = "" {
        didSet {
            view.setBackgroundLightEffect(thumb)
            collectionView?.backgroundColor = UIColor.clearColor()
        }
    }
    var status = ""
    var name = ""
    var rating = ""
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let d = detail {
            if d.sources.count > 0 {
                return d.sources[0].titles.count
            }
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DetailItemCollectionCell", forIndexPath: indexPath)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let c = cell as! DetailItemCollectionViewCell
        if playRecord != nil {
            
        } else {
            let source = detail!.sources[0]
            c.titleLabel.text = source.titles[indexPath.row]
        }
        c.thumb = thumb
        if indexPath.row == curIndex {
            cell.selected = true
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "DetailHeaderCell", forIndexPath: indexPath) as! DetailCollectionHeaderCell
        UIImageView.requestImageWithUrlString(thumb) { (image) -> Void in
            cell.thumbImage.image = image
            cell.setBackgroundDarkEffect(self.thumb)
        }
        updateHeaderUI(cell)
        cell.delegate = self
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueToPlayerIdentifier", sender: indexPath)
    }
    
    func updateHeaderUI(cell: DetailCollectionHeaderCell) {
        cell.statusLabel.text = status
        cell.nameLabel.text = name
        cell.rationgLabel.text = "评分: \(rating)"
        if let d = detail {
            cell.year.text = "年份: \(d.pub)"
            if d.sources.count > 1 {
                cell.sourceButton.setTitle(d.sources[curSource].name, forState: .Normal)
                cell.sourceButton.setImage(UIImage(named: "triangle"), forState: .Normal)
                cell.sourceButton.enabled = true
            } else if d.sources.count == 1 {
                cell.sourceButton.setTitle(d.sources[0].name, forState: .Normal)
                cell.sourceButton.setImage(nil, forState: .Normal)
                cell.sourceButton.enabled = false
            } else {
                cell.playButton.hidden = true
                cell.sourceButton.hidden = true
            }
        } else {
            cell.year.text = "年份: "
        }
    }

    func detailHeaderSourceButtonClick() {
        guard detail != nil else { return }
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        for index in 0..<detail!.sources.count {
            actionController.addAction(UIAlertAction(title: detail!.sources[index].name, style: .Default, handler: { (action) -> Void in
                self.curSource = index
                if let cell = self.collectionView?.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as? DetailCollectionHeaderCell {
                    self.updateHeaderUI(cell)
                }
                
            }))
        }
        
        actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        presentViewController(actionController, animated: true, completion: nil)

    }
    
    func detailHeaderPlayButtonClick() {
        performSegueWithIdentifier("segueToPlayerIdentifier", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? PlayerViewController {
            dvc.items = detail!.sources[curSource]
            if let indexPath = sender as? NSIndexPath {
                dvc.startIndex = indexPath.row
            } else {
                dvc.startIndex = curIndex
            }
        }
    }
}
