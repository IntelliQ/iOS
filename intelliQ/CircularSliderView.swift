//
//  CircularSliderView.swift
//  IntelliQ
//
//  Created by Markus Petrykowski on 07.12.15.
//  Copyright © 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

@IBDesignable
class CircularSliderView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor(red: (37.0/255.0), green: (252.0/255), blue: (244.0/255.0), alpha: 1.0)
    @IBInspectable var secondColor: UIColor = UIColor(red: (171.0/255.0), green: (250.0/255), blue: (81.0/255.0), alpha: 1.0)
   
    
    func addOval(lineWidth: CGFloat, path: CGPathRef, strokeStart: CGFloat, strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize) {
        
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.CGColor
        arc.fillColor = fillColor.CGColor
        arc.shadowColor = UIColor.blackColor().CGColor
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffsset
        layer.addSublayer(arc)
    }
    
    func addCirle(arcRadius: CGFloat, capRadius: CGFloat, color: UIColor) {
        let X = CGRectGetMidX(self.bounds)
        let Y = CGRectGetMidY(self.bounds)
        
        // Bottom Oval
        let pathBottom = UIBezierPath(ovalInRect: CGRectMake((X - (arcRadius/2)), (Y - (arcRadius/2)), arcRadius, arcRadius)).CGPath
        self.addOval(20.0, path: pathBottom, strokeStart: 0, strokeEnd: 0.5, strokeColor: color, fillColor: UIColor.clearColor(), shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
        
        // Middle Cap
        let pathMiddle = UIBezierPath(ovalInRect: CGRectMake((X - (capRadius/2)) - (arcRadius/2), (Y - (capRadius/2)), capRadius, capRadius)).CGPath
        self.addOval(0.0, path: pathMiddle, strokeStart: 0, strokeEnd: 1.0, strokeColor: color, fillColor: color, shadowRadius: 5.0, shadowOpacity: 0.5, shadowOffsset: CGSizeZero)
        
        // Top Oval
        let pathTop = UIBezierPath(ovalInRect: CGRectMake((X - (arcRadius/2)), (Y - (arcRadius/2)), arcRadius, arcRadius)).CGPath
        self.addOval(20.0, path: pathTop, strokeStart: 0.5, strokeEnd: 1.0, strokeColor: color, fillColor: UIColor.clearColor(), shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSizeZero)
        
    }
    
    //Defines the additional Space needed for the time and waiting user
    var outerPadding:CGFloat {
        return 30
    }
    
    var mainCircleRadius: CGFloat {
        return min(self.bounds.size.width, self.bounds.size.height) / 2
    }
    
    let angleOffset:CGFloat = (CGFloat(2*M_PI)/360)*270
    override func drawRect(rect: CGRect){
        
        let centeringCircle = UIBezierPath(arcCenter: convertPoint(center, fromView: self), radius: mainCircleRadius-8-outerPadding, startAngle: 0, endAngle: (CGFloat(2*M_PI)/360)*360, clockwise: true)
        centeringCircle.lineWidth = CGFloat(5)
        firstColor.set()
        centeringCircle.stroke()
        
        let centeringCircle1 = UIBezierPath(arcCenter: convertPoint(center, fromView: self), radius: mainCircleRadius-outerPadding, startAngle: angleOffset, endAngle: (CGFloat(2*M_PI)/360)*90+angleOffset, clockwise: true)
        centeringCircle1.lineWidth = CGFloat(5)
        UIColor.blueColor().set()
        centeringCircle1.stroke()
        
        centeringCircle1.currentPoint
    }
    
    
    func calcPointForAngle(startPoint:CGPoint, radius:CGFloat, angle:CGFloat) -> CGPoint {
        return startPoint
    }


}
