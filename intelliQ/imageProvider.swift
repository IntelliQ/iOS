//
//  imageProvider.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 25.11.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import Foundation

class ImageProvider{
    
    static let imageEndpoint = "http://intelliq.me/image/"
    
    class func getImage(id:Int, size:Int, callback: UIImage -> Void){
        let urlString = imageEndpoint + "\(id)/\(size).jpg"
        print(urlString)
        let imageUrl = NSURL(string: urlString)
        
        
        if let url = imageUrl {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue(), {
                    if imageData != nil {
                        callback(UIImage(data: imageData!)!)
                    }
                })
            })
        }

        
        
    }
}