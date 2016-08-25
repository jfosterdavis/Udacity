//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jacob Foster Davis on 8/23/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    //Set a pointer to the sharedMemes
    var sharedMemes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).sharedMemes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the special edit button that I can't figure out how to add via storyboard
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //refresh the data
        //realized I had to do this from forums and from Olivia Murphy code 
        //https://github.com/onmurphy/MemeMe/blob/master/MemeMe/TableViewController.swift
        self.tableView.reloadData()
    }
    
    //add swipe to delete function adapted from
    //http://stackoverflow.com/questions/24103069/swift-add-swipe-to-delete-tableviewcell
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //delete the meme from the Model
            deleteMeme(indexPath)
            //fade the row away.  From iOS Developer Library
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //self.tableView.reloadData()
        }
    }
    
    func deleteMeme(atIndexPath: NSIndexPath){
        print("About to delete meme at index: ", atIndexPath.row)
        //get an app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.sharedMemes.removeAtIndex(atIndexPath.row)
    }
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are ", String(self.sharedMemes.count), " shared Memes")
        return self.sharedMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print("From cellForRowAtIndexPath.  There are ", String(self.sharedMemes.count), " shared Memes")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.sharedMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = (meme.topText as String)
        cell.detailTextLabel?.text = (meme.bottomText as String)
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        //if let detailTextLabel = cell.detailTextLabel {
        //    detailTextLabel.text = "Scheme: \(villain.evilScheme)"
        //}
        
        return cell
    }

    //When a user selects an item from the table
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = self.sharedMemes[indexPath.row]
        print("about to show detail for meme at indexPath: ",indexPath.row)
        detailController.meme = meme
        //tell the detail contorller where this meme belongs in the shared model in case user wants to edit
        detailController.indexPath = indexPath
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}