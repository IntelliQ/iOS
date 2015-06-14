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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
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
            destinationVC.companyName = companies[selectedCompany!].name
        }
        tableView.deselectRowAtIndexPath(NSIndexPath(forRow: selectedCompany!, inSection: 0), animated: true)
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
        
        if let queues = defaults.objectForKey("queues") as? [String:String]{
            println(queues)
            for (company, waitingId) in queues {
                checkStatus(waitingId, companyId: company)
            }
            
        }
    }
    
    func checkStatus(waitingId: String?, companyId: String?){
        
        qProvider.checkStatus(waitingId!, companyId: companyId!){
            result -> Void in
            println(result)
            dispatch_async(dispatch_get_main_queue(), {
                
                if result["state"] == "ready"{
                    //Its your turn!
                    
                    for (index,company) in enumerate(self.companies) {
                        if company.id == result["companyId"] {
                            self.selectedCompany = index
                            
                            self.performSegueWithIdentifier("enqueue", sender: self)
                        }
                    }
                    
                }
                
            })
            
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

