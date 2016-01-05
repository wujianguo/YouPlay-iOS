//
//  MovieListCollectionViewController.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/4.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit


extension UIView {
    func setBackgroundLightEffect(image: UIImage) {
        let img = lightEffectImage(image)
        backgroundColor = UIColor(patternImage: img)
    }
    
    func setBackgroundDarkEffect(image: UIImage) {
        let img = darkEffectImage(image)
        backgroundColor = UIColor(patternImage: img)
    }
    
    func lightEffectImage(image: UIImage) -> UIImage {
        var img = image.applyLightEffectAtFrame(CGRectMake(0, 0, image.size.width, image.size.height))
        UIGraphicsBeginImageContext(self.frame.size);
        img.drawInRect(self.bounds)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func darkEffectImage(image: UIImage) -> UIImage {
        var img = image.applyDarkEffectAtFrame(CGRectMake(0, 0, image.size.width, image.size.height))
        UIGraphicsBeginImageContext(self.frame.size);
        img.drawInRect(self.bounds)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
}

class MovieItemCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    var thumbImage = UIImageView()
    var nameLabel = UILabel()
    var statusLabel = UILabel()
    var rationgLabel = UILabel()
    var actors = UILabel()
    
    func setup() {
        
        nameLabel.textColor = UIColor.whiteColor()
        statusLabel.textColor = UIColor.whiteColor()
        rationgLabel.textColor = UIColor.whiteColor()
        actors.textColor = UIColor.whiteColor()
        
        nameLabel.font = UIFont.systemFontOfSize(15)
        statusLabel.font = UIFont.systemFontOfSize(12)
        rationgLabel.font = UIFont.systemFontOfSize(12)
        actors.font = UIFont.systemFontOfSize(12)
        
        nameLabel.numberOfLines = 0
//        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        statusLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        rationgLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        actors.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        
        contentView.addSubview(thumbImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(rationgLabel)
        contentView.addSubview(actors)
        
        thumbImage.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.equalTo(thumbImage.snp_height).multipliedBy(1.0/1.5)
        }
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(thumbImage.snp_right).offset(18)
            make.top.equalTo(thumbImage).offset(8)
            make.right.equalTo(contentView).offset(-8)
        }
        
        rationgLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(nameLabel)
            make.bottom.equalTo(thumbImage.snp_bottom).offset(-8)
        }
        
        actors.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(nameLabel)
            make.bottom.lessThanOrEqualTo(rationgLabel.snp_top).offset(-12)
        }

        statusLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(nameLabel)
            make.bottom.lessThanOrEqualTo(actors.snp_top).offset(-12)
        }
    }
    
    func setupBackgroundEffect() {
        if let image = thumbImage.image {
            contentView.backgroundColor = UIColor(patternImage: contentView.darkEffectImage(image))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackgroundEffect()
    }
    
}


class MovieListCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.clearColor()
        queryItems(1) { (items) -> Void in
            self.items.appendContentsOf(items)
            self.collectionView?.reloadData()
            if items.count > 0 {
                self.setupBackgroundEffect(items[0].thumb)
            }
        }
    }
    
    func setupBackgroundEffect(url: String) {
        UIImageView.requestImageWithUrlString(url) { (image) -> Void in
            self.view.setBackgroundLightEffect(image)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if items.count > 0 {
            self.setupBackgroundEffect(items[0].thumb)
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let flowLayout = collectionView?.collectionViewLayout
        flowLayout?.invalidateLayout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? DetailCollectionViewController {
            if let cell = sender as? UICollectionViewCell {
                if let indexPath = collectionView?.indexPathForCell(cell) {
                    dvc.detailApi = items[indexPath.row].detail
                }
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    var items = [YouPlayItem]()
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieListCollectionCell", forIndexPath: indexPath) as! MovieItemCollectionViewCell
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let c = cell as? MovieItemCollectionViewCell {
            let item = items[indexPath.row]
            c.thumbImage.setImageWithUrlString(item.thumb) { (image) -> Void in
                c.setupBackgroundEffect()
            }
            c.actors.text = ""
            for a in item.actors {
                c.actors.text! += "\(a) "
            }
            c.nameLabel.text = item.title
            c.statusLabel.text = item.status
            c.rationgLabel.text = "评分：\(item.rating)"
        }
        
    }
    
    
    struct CellRatio {
        static let x = CGFloat(200)
        static let y = CGFloat(100)
    }
    
    let mininumInteritemSpacing = CGFloat(8)
    
    var collectionViewEdgeInset = UIEdgeInsetsMake(8, 8, 8, 8)
    
    func calculateCellNum(size: CGSize) -> Int {
        let width = size.width - collectionViewEdgeInset.left - collectionViewEdgeInset.right + mininumInteritemSpacing
        let num = width / (CellRatio.x + mininumInteritemSpacing)
        let actXNum = num - CGFloat(Int(num)) >= 0.7 ? Int(num) + 1 : Int(num)
        return actXNum > 0 ? actXNum : 1
    }
    
    var collectionCellWidth: CGFloat {
        let bounds = collectionView!.bounds
        let width = bounds.width - collectionViewEdgeInset.left - collectionViewEdgeInset.right + mininumInteritemSpacing
        let n = calculateCellNum(bounds.size)
        return width/CGFloat(n) - mininumInteritemSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionCellWidth
        return CGSizeMake(width, width*CellRatio.y/CellRatio.x)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return mininumInteritemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return collectionViewEdgeInset
    }
    
    
}
