//
//  CompanyTableViewCell.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 13.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    var company:Company? {
        didSet {
            updateCell()
        }
    }
    
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var peopleWaiting: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func updateCell(){
        companyName.text = company!.name!
        peopleWaiting.text = String(company!.waiting!)
        
        var imageUrl:NSURL?
        
        if let url = company?.logo {
            imageUrl = NSURL(string: url)
        }
        
        if let url = imageUrl {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue(), {
                    if imageData != nil {
                        self.companyLogo.image = UIImage(data: imageData!)
                        
                    }
                })
            })
        }
    }
}
