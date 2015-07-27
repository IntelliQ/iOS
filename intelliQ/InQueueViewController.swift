//
//  InQueueViewController.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 13.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class InQueueViewController: UIViewController {

//    let defaults = NSUserDefaults.standardUserDefaults()
    let defaults = NSUserDefaults(suiteName: "group.me.intelliQ")!
    
    var companyId:String?,
        qProvider = QProvider(),
        waitingId:String?,
        updateTimer:NSTimer?,
        companyAvgTime:Int?,
        companyName:String?
    
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
        myBackButton.setTitle("＜ " + "back".localized, forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        self.title = companyName!
        
        if let queues = defaults.objectForKey("queues") as? [String:String]{
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
        var nickname = "Anonymus"
        if let name = defaults.objectForKey("username") as? String{
            nickname = name
        }
        qProvider.enqueMe(nickname, company: companyId!){
            newId -> Void in
            self.waitingId = newId
            self.storeQueue()
            self.checkStatus()
        }
    }
    
    func checkStatus(){
        
        qProvider.checkStatus(waitingId!, companyId: companyId!){
            result -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if result["state"] == "ready"{
                    //Its your turn!
                    self.waitingFinished()
                }else {
                    self.ticketId.text = result["ticketId"]
                    self.inLine.text = result["peopleAhead"]
                    var minutes = self.companyAvgTime! * (result["peopleAhead"])!.toInt()!
                    self.minutesLeft.text = "\(minutes) min"
                }
                
            })

        }
    }
    
    func notifyUser(){
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "\(companyName!)"
        localNotification.alertBody = "your_turn".localized
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func waitingFinished(){
        notifyUser()
        var alert = UIAlertController(title: "\(companyName!)", message: "your_turn".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.returnToList(UIBarButtonItem())
        }))
            
        self.presentViewController(alert, animated: true, completion: nil)
        
        if let queues = defaults.objectForKey("queues") as? [String:String]{
            var newQueues = queues
            
            newQueues.removeValueForKey(companyId!)
            defaults.setObject(newQueues, forKey: "queues")
        }
        
        updateTimer!.invalidate()
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

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}
