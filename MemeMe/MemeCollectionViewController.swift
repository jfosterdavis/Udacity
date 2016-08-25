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
    
    //flow layout
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Set a pointer to the sharedMemes
    var sharedMemes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).sharedMemes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let space: CGFloat!
        let dimension: CGFloat!
        
        //following layout approach adapted from
        //http://stackoverflow.com/questions/34132766/uicollectionview-resizing-cells-on-device-rotate-swift
        //http://swiftiostutorials.com/tutorial-using-uicollectionview-uicollectionviewflowlayout/
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) { //If landscape mode
            //implement flow layout
            space = 3.0
            // have 4 items across if in landscape
            let numberOfItems: CGFloat = 4
            let spacingConstant: CGFloat = numberOfItems - 1
            dimension = (self.view.frame.size.width - (2 * space) - (spacingConstant * space)) / numberOfItems
        } else { //if portrait mode
            //implement flow layout
            space = 3.0
            // have 3 items across if in portrait
            let numberOfItems: CGFloat = 3
            let spacingConstant: CGFloat = numberOfItems - 1
            dimension = (self.view.frame.size.width - (2 * space) - (spacingConstant * space)) / numberOfItems
        }
        //set the flowLayout based on new values
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
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
        
        //print("From cellForItemAtIndexPath.  There are ", String(self.sharedMemes.count), " shared Memes")
        
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
        //tell the detail contorller where this meme belongs in the shared model in case user wants to edit
        detailController.indexPath = indexPath
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}