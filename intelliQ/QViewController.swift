//
//  ViewController.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 12.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class QViewController: UITableViewController{

    var qProvider:QProvider = QProvider()
    var companies:[Company] = []
    var isLoading = false
    var selectedCompany:Int?
    var updateTimer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "reload", userInfo: nil, repeats: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? InQueueViewController {
            destinationVC.companyId = companies[selectedCompany!].id
            destinationVC.companyAvgTime = companies[selectedCompany!].avgWaitingTime
        }
        updateTimer?.invalidate()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("company", forIndexPath: indexPath) as! CompanyTableViewCell
        
        cell.company = companies[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCompany = indexPath.row
        
        self.performSegueWithIdentifier("enqueue", sender: self)
    }
    
    func reload(){
        loadCompanies(true){() -> Void in
        
        }
    }
    
    
    func loadCompanies (reset: Bool, callback: () -> Void) {
        if !isLoading {
            self.isLoading = true
            qProvider.getCompanies() { (companies) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.companies = companies
                    self.tableView.reloadData()
                    self.isLoading = false
                    callback()
                })
            }
        }
    }
    
    func refresh(){
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        loadCompanies(true) {() -> Void in
            sender?.endRefreshing()
        }
    }
    
}

