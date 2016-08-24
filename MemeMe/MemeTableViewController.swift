//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jacob Foster Davis on 8/23/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Set a pointer to the sharedMemes
    var sharedMemes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).sharedMemes
    }
    
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sharedMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.sharedMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = (meme.topText as String) + " " + (meme.bottomText as String)
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        //if let detailTextLabel = cell.detailTextLabel {
        //    detailTextLabel.text = "Scheme: \(villain.evilScheme)"
        //}
        
        return cell
    }

    //if I add function to happen when I select a row it will go here.
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
//        
//    }
    
}