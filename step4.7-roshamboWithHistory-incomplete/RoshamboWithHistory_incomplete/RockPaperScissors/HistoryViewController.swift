//
//  HistoryViewController.swift
//  RockPaperScissors
//
//  Created by Jacob Foster Davis on 8/17/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {
    
    var history = [RPSMatch]()

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell")!
        let historyEntry = self.history[indexPath.row]
        
        // Set the name
        cell.textLabel?.text = historyResultString(historyEntry)
        print("Attempted to set label to")
        print(historyResultString(historyEntry))
        //cell.imageView?.image = UIImage(named: villain.imageName)
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = detailResultsString(historyEntry)
        }
        
        return cell
    }
    
    func historyResultString(match: RPSMatch) -> String {
        // Handle the tie
        if match.p1 == match.p2 {
            return "Tie."
        }
        else {
            return match.p1.defeats(match.p2) ? "Win!" : "Loss."
        }
    }
    
    func detailResultsString(match: RPSMatch) -> String {
        //call the method used during the actual match
        let resultVC = ResultViewController()
        return resultVC.messageForMatch(match)
    }
}