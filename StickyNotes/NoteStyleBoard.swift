//
//  NoteStyleBoard.swift
//  
//
//  Created by pingRuiLiao on 2016/3/31.
//
//

import UIKit

protocol NoteStyleDelegate {
    func changeNoteStyle(_ imgNamed: NoteStyle)
}

enum NoteStyle: String {
    case yellow = "noteYellow"
    case red = "noteRed"
    case blue = "noteBlue"
    case texty = "noteTexty"
}


class NoteStyleBoard: UIView {
    
    @IBOutlet var theView: NoteStyleBoard!
    var delegate: NoteStyleDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        
        Bundle.main.loadNibNamed("NoteStyleBoard", owner: self, options: nil)
        self.theView.frame = CGRect(origin: CGPoint(x: 50.0, y: 400), size: CGSize(width: 300.0, height: 300.0))
        self.addSubview(theView)
    }
    
    func endChoosingNoteStyle() {
        theView.removeFromSuperview()
        self.removeFromSuperview()
    }
    @IBAction func btnYellowSticker(_ sender: AnyObject) {
        delegate?.changeNoteStyle(NoteStyle.yellow)
        endChoosingNoteStyle()
    }
    @IBAction func btnRedSticker(_ sender: AnyObject) {
        delegate?.changeNoteStyle(NoteStyle.red)
        endChoosingNoteStyle()
    }
    @IBAction func btnBlueSticker(_ sender: AnyObject) {
        delegate?.changeNoteStyle(NoteStyle.blue)
        endChoosingNoteStyle()
    }
    @IBAction func btnTextSticker(_ sender: AnyObject) {
        delegate?.changeNoteStyle(NoteStyle.texty)
        endChoosingNoteStyle()
    }
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        endChoosingNoteStyle()
    }
}
