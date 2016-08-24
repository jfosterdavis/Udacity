//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jacob Foster Davis on 8/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //Set a pointer to the sharedMemes
    var sharedMemes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).sharedMemes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //refresh the data
        //realized I had to do this from forums and from Olivia Murphy code
        //https://github.com/onmurphy/MemeMe/blob/master/MemeMe/TableViewController.swift
        self.collectionView!.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are ", String(self.sharedMemes.count), " shared Memes")
        return self.sharedMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        print("From cellForItemAtIndexPath.  There are ", String(self.sharedMemes.count), " shared Memes")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! CustomMemeCollectionViewCell
        let meme = self.sharedMemes[indexPath.row]
        
        // Set the image
        //cell.setText(meme.topText as String) + " " + (meme.bottomText as String)
        cell.imageView.image = meme.memedImage
        
        return cell
    }
    
    //When a user selects an item from the collection
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = self.sharedMemes[indexPath.row]
        print("about to show detail from the collection view for meme at indexPath: ",indexPath.row)
        detailController.meme = meme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}