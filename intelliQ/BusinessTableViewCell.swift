//
//  BusinessTableViewCell.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 06.11.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var queues: UITableView!
    @IBOutlet weak var queuesHeight: NSLayoutConstraint!
    @IBOutlet weak var businessLogo: UIImageView!
    
    var business:Business? {
        didSet{
            updateCell()
        }
    }
    var rootViewController:QueueListController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        queues.dataSource = self
        queues.delegate = self
        
        queues.separatorStyle = UITableViewCellSeparatorStyle.None
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(){
        businessName.text = business!.name!
        
        
        let logoWidth:Int = Int(businessLogo.bounds.size.width)
        ImageProvider.getImage(business!.logoImageKey!, size: logoWidth) {
            image in
            
            self.businessLogo.image = image
        }

        
        
        queuesHeight.constant = CGFloat((business?.queues.count)!) * queues.rowHeight
        queues.layoutIfNeeded()
        
        self.layoutSubviews()
        self.sizeToFit()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if business != nil {
            return (business?.queues.count)!
        }else{
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessQueue", forIndexPath: indexPath) as! QueueTableViewCell
        
        cell.queue = business?.queues[indexPath.row]
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let singleQueueBusiness = business
        singleQueueBusiness?.queues = [(business?.queues[indexPath.row])!]
        rootViewController?.openQueue(singleQueueBusiness!)
    }
    
    func getSelectedQueue() -> Business{
        let indexPath = queues!.indexPathForSelectedRow!
        let singleQueueBusiness = business
        singleQueueBusiness?.queues = [(business?.queues[indexPath.row])!]
        return singleQueueBusiness!
    }
}
