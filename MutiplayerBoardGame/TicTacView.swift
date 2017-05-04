//
//  TicTacView.swift
//  MutiplayerBoardGame
//
//  Created by eric yu on 4/28/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit

class TicTacView: UIView {
    var path: UIBezierPath = {
        let p = UIBezierPath()
        UIColor.black.setStroke()
        p.lineWidth = 3
        return p
    }()
    
    let shapeLayer:CAShapeLayer = {
        let sl = CAShapeLayer()
        sl.strokeColor = UIColor.black.cgColor
        sl.fillColor = UIColor.clear.cgColor
        sl.lineWidth = 2.0
        sl.lineCap = kCALineCapRound
        return sl
    }()
    
    let animation:CABasicAnimation = {
        let an = CABasicAnimation(keyPath: "strokeEnd")
        an.fromValue = 0.0
        an.toValue = 1.0
        an.duration = 1
        an.fillMode = kCAFillModeForwards
        an.isRemovedOnCompletion = false
        return an
    }()
        override func draw(_ rect: CGRect) {
          
         
            path.move(to: CGPoint(x: 0, y: self.frame.height/3))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height/3))
            
            //x ln 2
            path.move(to: CGPoint(x: 0, y: self.frame.height * (2/3)))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height * (2/3)))
         
            //y ln 1
            path.move(to: CGPoint(x: self.frame.width/3, y: 0))
            path.addLine(to: CGPoint(x: self.frame.width/3, y: self.frame.height))
          
            //y ln2
            path.move(to: CGPoint(x: self.frame.width * (2/3), y: 0))
            path.addLine(to: CGPoint(x: self.frame.width * (2/3), y: self.frame.height))
          
            shapeLayer.path = path.cgPath

        }
    
    func drawIt(){
        layer.addSublayer(shapeLayer)
        shapeLayer.add(animation, forKey: "drawLineAnimation")
    }
    


}
