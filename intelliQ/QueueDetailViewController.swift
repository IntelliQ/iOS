//
//  QueueDetailViewController.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 02.12.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class QueueDetailViewController: UIViewController {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var queueName: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var business:Business?
    var queueIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.tintColor = UIColor.whiteColor()
            
        updateUI()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func updateUI(){
        let screenWidth = Int(UIScreen.mainScreen().bounds.size.width)+10
        
        ImageProvider.getImage((business?.queues[queueIndex!].imageId)!, size: screenWidth ){
            image in
            self.titleImage.image = image
        }
        
        ImageProvider.getImage(business!.logoImageKey!, size: Int(logoImage.bounds.width) ){
            image in
            self.logoImage.image = image
        }
        
        queueName.text = business?.queues[queueIndex!].name
    }

    @IBAction func closeQueue(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            print(self.business?.name)
        })
    }
}
