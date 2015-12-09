//
//  MainNavigationController.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 01.11.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import YSSegmentedControl
import UIKit

class QueueListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    
    var provider = QueueProvider()
    var queueList:[Business] = []
    var height = CGFloat(0)
    var selectedBusiness:Business?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destViewController = segue.destinationViewController as? QueueDetailViewController {
            destViewController.business = selectedBusiness
        }
        
    }
    
    
    func openQueue(business:Business){
        selectedBusiness = business
        self.performSegueWithIdentifier("openQueue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 189
        tableView.rowHeight = UITableViewAutomaticDimension
        
        provider.getNearbyBusinesses() {
            (queueList) -> Void in
            
            //Reload Data in Mainqueue
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.queueList = queueList
                self.tableView.reloadData()
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queueList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("queueBusiness", forIndexPath: indexPath) as! BusinessTableViewCell
        
        cell.business = queueList[indexPath.row]
        cell.rootViewController = self
        
        return cell
//        let cell = tableView.dequeueReusableCellWithIdentifier("testCell", forIndexPath: indexPath)
//        
//        cell.textLabel?.text = queueList[indexPath.row].name!
//        
//        return cell
    }

    func refresh(){
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func showMenu(sender: UIBarButtonItem) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
        
        let settings = UIAlertAction(title: "Settings", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("go to settings")
        })
        
        //
        let createQueue = UIAlertAction(title: "Create Queue", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("create Queue")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("cancel")
        })
    
        optionMenu.addAction(cancel)
        optionMenu.addAction(createQueue)
        optionMenu.addAction(settings)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
}
