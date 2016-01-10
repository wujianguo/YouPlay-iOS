//
//  MovieListViewController.swift
//  YouPlay-iOS
//
//  Created by wujianguo on 16/1/5.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit


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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupThumbImage(photoRecord?.url)
    }
    
    func setupThumbImage(url: NSURL?) {
        guard url != nil else { return }
        photoRecord = PhotoRecord(bounds: bounds, url: url!)
        downloadOperation?.cancel()
        let downOp = ImageDownloader(photoRecord: photoRecord!)
        downloadOperation = downOp
        downOp.completionBlock = {
            if downOp.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
                self?.thumbImage.image = self?.downloadOperation?.photoRecord.image
            }
        }
        MovieItemCollectionViewCell.pendingOperations.downloadQueue.addOperation(downOp)
        
        filterOperation?.cancel()
        let filterOp = ImageFiltration(photoRecord: photoRecord!)
        filterOperation = filterOp
        filterOp.completionBlock = {
            if filterOp.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
                self?.contentView.backgroundColor = self?.filterOperation?.photoRecord.color
            }
        }
        filterOp.addDependency(downOp)
        MovieItemCollectionViewCell.pendingOperations.filtrationQueue.addOperation(filterOp)
    }
    
    
    var photoRecord: PhotoRecord?
    var downloadOperation: ImageDownloader?
    var filterOperation: ImageFiltration?
    
    static let pendingOperations = PendingOperations()
}

class MovieListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView?.backgroundColor = UIColor.clearColor()
        requestMoreData()
    }
    
    let titleButton = UIButton()
    
    func channelChangedTo(channel: YouPlaychannel) {
        self.channel = channel
        items.removeAll()
        itemIndex = 1
        collectionView.reloadData()
        requestMoreData()
    }
    
    func setupBackgroundEffect(url: String) {
        view.setBackgroundLightEffect(url)
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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        channelChangedTo(YouPlaychannel(rawValue: sender.selectedSegmentIndex)!)
    }

    
    var items = [YouPlayItem]()
    var itemIndex = 1
    var thumbs = [PhotoRecord]()
    let pendingOperations = PendingOperations()
    
    var channel = YouPlaychannel.Teleplay
    
    func requestMoreData() {
        let c = channel
        queryItems(channel, page: itemIndex) { (items, succ) -> Void in
            guard succ && c == self.channel else { return }
            var indexPaths = [NSIndexPath]()
            for i in 0..<items.count {
                indexPaths.append(NSIndexPath(forRow: self.items.count + i, inSection: 0))
            }
            self.itemIndex += 1
            self.items.appendContentsOf(items)
//            self.collectionView?.reloadData()
            self.collectionView.insertItemsAtIndexPaths(indexPaths)
            if items.count > 0 && self.itemIndex == 2 {
                self.setupBackgroundEffect(items[0].thumb)
            }
            
        }

    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieListCollectionCell", forIndexPath: indexPath) as! MovieItemCollectionViewCell
        if indexPath.row == items.count - 1 {
            requestMoreData()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let c = cell as? MovieItemCollectionViewCell {
            let item = items[indexPath.row]
            if let url = NSURL(string: item.thumb) {
                c.setupThumbImage(url)
            }

            c.actors.text = ""
            for a in item.actors {
                c.actors.text! += "\(a) "
            }
            c.nameLabel.text = item.title
            c.statusLabel.text = item.status
            c.rationgLabel.text = "评分: \(item.rating)"
        }
    }

    struct CellRatio {
        static let x = CGFloat(250)
        static let y = CGFloat(125)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? DetailCollectionViewController, let cell = sender as? UICollectionViewCell {
            if let indexPath = collectionView.indexPathForCell(cell) {
                let item = items[indexPath.row]
                dvc.detailApi = item.detail
                dvc.thumb = item.thumb
                dvc.status = item.status
                dvc.name = item.title
                dvc.rating = item.rating
            }
            
        }
    }
    

}
