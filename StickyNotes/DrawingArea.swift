//
//  DrawingArea.swift
//  StickyNotes
//
//  Created by pingRuiLiao on 2017/10/17.
//  Copyright © 2017年 pingRuiLiao. All rights reserved.
//

import Foundation
//
//  Note.swift
//  AdhesiveNote
//
//  Created by pingRuiLiao on 2016/3/31.
//  Copyright © 2016年 pingRuiLiao. All rights reserved.
//


import UIKit

enum DrawingMode {
    case pen
    case eraser
}

class DrawingArea: UIImageView {
    
    var mode = DrawingMode.pen
    var currentPoint: CGPoint?
    var isDot: Bool = false
    var imgForEraserColor: UIImage?
    var colorUsed: PenColor = PenColor.black
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupEraserAs(NoteStyle.yellow.rawValue)
    }
    
    
    func setupEraserAs(_ imgNamed: String) {
        
        self.image = UIImage(named: imgNamed)!
        self.frame.size = CGSize(width: 350.0, height: 350.0)
        
        UIGraphicsBeginImageContext(self.frame.size)
        self.image?.draw(in: CGRect(origin: CGPoint.zero, size: self.frame.size))
        self.image! = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        imgForEraserColor = self.image!
        self.isUserInteractionEnabled = true
    }
    
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDot = true
        let touch = touches.first!
        currentPoint = touch.location(in: self)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDot = false
        let touch = touches.first!
        let newPoint = touch.location(in: self)
        drawLineFrom(currentPoint!, toPoint: newPoint)
        currentPoint = newPoint
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDot {
            drawLineFrom(currentPoint!, toPoint: currentPoint!)
        }
    }
    
    func drawLineFrom( _ fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(CGLineCap.round)
        
        switch mode {
        case .pen:
            context?.setStrokeColor(colorUsed.toUIColor()!.cgColor)
            //CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
            context?.setLineWidth(5)
        case .eraser:
            let bgColor = UIColor(patternImage: imgForEraserColor!)
            context?.setStrokeColor(bgColor.cgColor)
            context?.setLineWidth(50)
            //        default:
            //            CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
            
        }
        context?.setBlendMode(CGBlendMode.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 1.0
        UIGraphicsEndImageContext()
        
    }
    
}
