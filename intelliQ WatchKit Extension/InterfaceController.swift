//
//  InterfaceController.swift
//  intelliQ WatchKit Extension
//
//  Created by Markus Petrykowski on 14.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var isLoading = false,
        qProvider = QProvider(),
        companies:[Company] = [],
        updateTimer:NSTimer?
    
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "loadTableData", userInfo: nil, repeats: true)
        loadTableData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        updateTimer?.invalidate()
    }
    
    func loadTableData(){
        
        if !isLoading {
            qProvider.getCompanies(){ (companies) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.companies = companies
                    
                    self.tableView.setNumberOfRows(self.companies.count, withRowType: "queueListItem")
                    
                    for (index, company) in enumerate(self.companies) {
                        if let row = self.tableView.rowControllerAtIndex(index) as? queueListItem {
                            row.companyName.setText(company.name!)
                            row.personsAhead.setText("\(company.waiting!) persons waiting")
                            
                        }
                    }
                    
                    self.isLoading = false
                    
                })
            }
        }
        
    }


}
