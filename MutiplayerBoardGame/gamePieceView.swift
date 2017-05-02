//
//  gamePieceView.swift
//  MutiplayerBoardGame
//
//  Created by eric yu on 4/29/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit

class gamePieceView: UIView {
    
    
    var player:String?
    var activated:Bool! = false
    
    func setPlayer(player:String){
        self.player = player
        
        if activated == false {
            if player == "x" {
                 drawItX()
            }else{
                 drawItO()
            }
        }
    }
    
    var path:UIBezierPath = {
        let p = UIBezierPath()
        UIColor.black.setStroke()
        p.lineWidth = 2.0
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
    
    let shapeLayer2:CAShapeLayer = {
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
    
    
    /*
    override func draw(_ rect: CGRect)
    {
    }
    */
 
    
    
    func drawItO(){
        allowMutipleClick()
        let fc = CGPoint(x: frame.width/2, y: frame.height/2)
        path.addArc(withCenter: fc , radius: frame.height/2.2, startAngle: CGFloat(-Double.pi*(2/4)), endAngle:CGFloat(Double.pi*(6/4)) , clockwise: true)
      // path.stroke() needs to be inside draw to work
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        shapeLayer.add(animation, forKey: "drawLineAnimation")

    }
    
    func drawItX(){
        allowMutipleClick()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.move(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        
        shapeLayer2.path = path.cgPath
        
        
        layer.addSublayer(shapeLayer2)
        
        shapeLayer2.add(animation, forKey: "drawLineAnimation")
   
    }
    func clear(){
     
        guard let sublayers = self.layer.sublayers else { return}
        
        for layer in sublayers {
            
            layer.removeFromSuperlayer()
        }
        
        path.removeAllPoints()//if old path not removed animation became faster
    }
    
    func allowMutipleClick(){
        //clear previous path so animation won't speed up after mutiple clicks
        path.removeAllPoints()
    }
    

}


