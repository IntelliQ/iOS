//
//  QueueTableViewCell.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 06.11.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import ChameleonFramework
import UIKit

class QueueTableViewCell: UITableViewCell {

    @IBOutlet weak var queueImage: UIImageView!
    @IBOutlet weak var imageOverlay: UIView!
    @IBOutlet weak var queueName: UILabel!
    
    var queue:BusinessQueue? {
        didSet {
            updateCell()
        }
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(){
        //Update QueueName
        queueName.text = queue?.name
        
        let imageWidth = Int(UIScreen.mainScreen().bounds.size.width)+10
        
        ImageProvider.getImage(queue!.imageId!, size: imageWidth){
            image in
                let palette = ColorsFromImage(image, withFlatScheme: true)
//                let avgColor =  AverageColorFromImage(image)
                let overlayColor = palette[0]
            
                let contrastingColor = ContrastColorOf(overlayColor, returnFlat: false)
                let colorWhite = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha:1.0)
                var animateName = false
                
                self.queueImage.alpha = 0
                self.queueImage.image = image
                
                if(contrastingColor != colorWhite){
                    animateName = true
                }
                UIView.animateWithDuration(1.5,
                    animations: {
                        self.queueImage.alpha = 1.0
                        self.imageOverlay.backgroundColor = overlayColor
                        if(animateName){
                            self.queueName.alpha = 0
                        }
                    },
                    completion: {
                        finished in
                        self.queueName.textColor = contrastingColor
                        UIView.animateWithDuration(0.5, animations: {self.queueName.alpha = 1.0})
                })

            
        }

    }
}
