//
//  InQueueViewController.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 13.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class InQueueViewController: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    var companyId:String?,
        qProvider = QProvider(),
        waitingId:String?,
        updateTimer:NSTimer?,
        companyAvgTime:Int?
    
    @IBOutlet weak var minutesLeft: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var ticketId: UILabel!
    @IBOutlet weak var inLine: UILabel!
    @IBOutlet weak var leaveQueue: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        myBackButton.addTarget(self, action: "returnToList:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("Back", forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        if let queues = defaults.objectForKey("queues") as? [String:String]{
            println(queues)
            if let existingWaitingId = queues[companyId!]{
                waitingId = existingWaitingId
                checkStatus()
            }else {
                enqueue()
            }
        }else{
            enqueue()
        }
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "checkStatus", userInfo: nil, repeats: true)
    }
    
    override func viewWillLayoutSubviews() {
        var height:CGFloat = 600
        contentView.frame = CGRectMake(0, 0, contentView.frame.width, height)
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: height)
    }
    func enqueue(){
        qProvider.enqueMe("Markus", company: companyId!){
            newId -> Void in
            self.waitingId = newId
            self.storeQueue()
            self.checkStatus()
        }
    }
    
    func checkStatus(){
        
        qProvider.checkStatus(waitingId!, companyId: companyId!){
            result -> Void in
            println(result)
            dispatch_async(dispatch_get_main_queue(), {
                self.ticketId.text = result["ticketId"]
                self.inLine.text = result["peopleAhead"]
                var minutes = self.companyAvgTime! * (result["peopleAhead"])!.toInt()!
                self.minutesLeft.text = "\(minutes) min"
            })

        }
    }
    
    
    func cancel(){
        if waitingId != nil {
            qProvider.cancelWaiting(waitingId!)
        }
        returnToList(UIBarButtonItem())
    }
    
    func returnToList(sender:UIBarButtonItem){
        updateTimer!.invalidate()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func leaveQueue(sender: UIButton) {
        cancel()
        if let queues = defaults.objectForKey("queues") as? [String:String]{
            var newQueues = queues
            
            newQueues.removeValueForKey(companyId!)
            defaults.setObject(newQueues, forKey: "queues")
        }
    }
    
    func storeQueue(){
        if let queues = defaults.objectForKey("queues") as? [String:String]{
            var newQueues = queues
            newQueues[companyId!] = waitingId!
            defaults.setObject(newQueues, forKey: "queues")
        }else{
            var queues:[String:String] = [companyId!: waitingId!]
            defaults.setObject(queues, forKey: "queues")
        }
    }
}
