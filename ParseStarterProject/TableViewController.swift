//
//  TableViewController.swift
//  ParseStarterProject
//
//  Created by Mat on 31/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class TableViewController: PFQueryTableViewController {
    
    
    @IBAction func signOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Conditions"
        self.textKey = "nameCondition"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Conditions")
        query.orderByAscending("nameCondition")
        return query
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell!
        if cell == nil {
            cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let nameCondition = object?["nameCondition"] as? String {
            cell?.textLabel?.text = nameCondition
        }
      //  if let capital = object?["capital"] as? String {
       //     cell?.detailTextLabel?.text = capital
       // }
        var initialThumbnail = UIImage(named: "question")
        //cell.customImage.image = initialThumbnail
        if let thumbnail = object?["image"] as? PFFile {
           // cell.customImage.file = thumbnail
           // cell.customImage.loadInBackground()
        }
        
        
        return cell
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        var detailScene = segue.destinationViewController as! DetailViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let row = Int(indexPath.row)
            detailScene.currentObject = (objects?[row] as! PFObject)
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let objectToDelete = objects?[indexPath.row] as! PFObject
            objectToDelete.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // Force a reload of the table - fetching fresh data from Parse platform
                    self.loadObjects()
                } else {
                    // There was a problem, check error.description
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
