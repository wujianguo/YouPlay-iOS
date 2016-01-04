//
//  MovieListCollectionViewController.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/4.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit


class MovieListCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        queryItems(1) { (items) -> Void in
            self.items.appendContentsOf(items)
            self.collectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieListCollectionCell", forIndexPath: indexPath)
    
        let image = UIImageView()
        cell.backgroundView = image
        image.setImageWithUrlString(items[indexPath.row].thumb)
        
        return cell
    }
    
}
