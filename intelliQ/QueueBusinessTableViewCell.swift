//
//  QueueBusinessTableViewCell.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 04.11.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class QueueBusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var queueName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var peopleWaiting: UILabel!
    var height = CGFloat(0)
    
    var provider = QueueProvider()
    
    var qBusiness:BusinessQueue? {
        didSet{
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(){
        queueName.text = qBusiness!.name!
        address.text = "\(qBusiness!.street!) \(qBusiness!.streetNumber!)"
        peopleWaiting.text = "\(qBusiness!.waitingPeople!) people waiting"
        
        var imageUrl:NSURL?
        
        let urlString = "http://intelliq.me/image/\(qBusiness!.imageId!)/400.jpg"
        imageUrl = NSURL(string: urlString)
        
        
        if let url = imageUrl {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue(), {
                    if imageData != nil {
                        self.businessImage.image = UIImage(data: imageData!)
                        
                    }
                })
            })
        }
        
//        height += (businessImage.image?.size.height)!
//        height += queueName.frame.height
//        height += address.frame.height
//        height += 20
    }

}
