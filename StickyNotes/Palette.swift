//
//  Palette.swift
//  StickerBoard
//
//  Created by pingRuiLiao on 2015/8/17.
//  Copyright (c) 2015年 pingRuiLiao. All rights reserved.
//

import UIKit

enum PenColor: String {
    
    case black = "black"
    case white = "white"
    case red = "red"
    case green = "green"
    case blue = "blue"
    case yellow = "yellow"
    func toUIColor() -> UIColor? {
        switch(self) {
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .blue:
            return UIColor.blue
        case .yellow:
            return UIColor.yellow
        /*default:
            return nil*/
        }
    }
}

protocol PaletteProtocol {
    func changeColorTo(_ color: PenColor)
}

class Palette: UIView {

    @IBOutlet var theView: Palette!
    var currentColor: PenColor? {
        didSet {
            self.CurrentColorView.backgroundColor = currentColor?.toUIColor()
        }
    }
    var delegate: PaletteProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        Bundle.main.loadNibNamed("Palette", owner: self, options: nil)
        self.theView.frame = CGRect(origin: CGPoint(x: 7.0, y: 350.0), size: CGSize(width: 400.0, height: 283.0))
        self.addSubview(self.theView)

    }
    
    @IBAction func useBlackColor(_ sender: AnyObject) {
        currentColor = PenColor.black
        CurrentColorView.backgroundColor = UIColor.black
    }
    @IBAction func useYellowColor(_ sender: AnyObject) {
        currentColor = PenColor.yellow
        CurrentColorView.backgroundColor = UIColor.yellow
    }
    @IBAction func useRedColor(_ sender: AnyObject) {
        currentColor = PenColor.red
        CurrentColorView.backgroundColor = UIColor.red
    }
    @IBAction func useBlueColor(_ sender: AnyObject) {
        currentColor = PenColor.blue
        CurrentColorView.backgroundColor = UIColor.blue
    }
    @IBAction func useWhiteColor(_ sender: AnyObject) {
        currentColor = PenColor.white
        CurrentColorView.backgroundColor = UIColor.white
    }
    @IBAction func useGreenColor(_ sender: AnyObject) {
        currentColor = PenColor.green
        CurrentColorView.backgroundColor = UIColor.green
    }
    @IBOutlet weak var CurrentColorView: UIView!

    @IBAction func btnOK(_ sender: AnyObject) {
        
        delegate?.changeColorTo(currentColor!)
        theView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    
    
    
    

}
