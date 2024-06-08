//
//  NoteViewController.swift
//  StickyNotes
//
//  Created by pingRuiLiao on 2017/10/17.
//  Copyright © 2017年 pingRuiLiao. All rights reserved.
//

import UIKit

protocol NoteDataSource {
    func getNoteData(noteData data: NoteData, collectionViewIndex index: Int)
    
}


class NoteViewController: UIViewController, PaletteProtocol, NoteStyleDelegate {
    
    var noteData = NoteData()
    var dataSource: NoteDataSource?
    var indexOnBoard: Int!
    @IBOutlet weak var drawingArea: DrawingArea!
    
    @IBOutlet weak var penButtonOutlet: UIButton!
    @IBOutlet weak var eraserButtonOutlet: UIButton!
    // MARK : LIFE CYCLE & SETTINGS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawingArea.setupEraserAs(noteData.eraserImage.rawValue)
        self.drawingArea.image = noteData.image
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.view.backgroundColor = .black
        return UIStatusBarStyle.lightContent
    }

    // MARK: PEN & ERASER
    @IBAction func penButtonIsClicked() {
        self.drawingArea.mode = DrawingMode.pen
        self.penButtonOutlet.setImage(UIImage(named: "penWithSpark"), for: UIControlState())
        self.eraserButtonOutlet.setImage(UIImage(named: "eraser"), for: UIControlState())
    }
    @IBAction func eraserButtonIsClicked() {
        self.drawingArea.mode = DrawingMode.eraser
        self.penButtonOutlet.setImage(UIImage(named: "pen"), for: UIControlState())
        self.eraserButtonOutlet.setImage(UIImage(named: "eraserWithSpark"), for: UIControlState())
    }
    
    // MARK: PALETTE
    @IBAction func paletteButtonIsClicked() {
        let frame = CGRect(origin: CGPoint(x: 7.0, y: 420.0), size: CGSize(width: 400.0, height: 283.0))
        let palette = Palette(frame: frame)
        palette.currentColor = self.drawingArea.colorUsed
        palette.delegate = self
        self.view.addSubview(palette)
    }
    func changeColorTo(_ color: PenColor) {
        self.drawingArea.colorUsed = color
        self.penButtonIsClicked()
    }
    
    // MARK: NOTE STYLE
    
    @IBAction func noteStyleButtonIsClicked() {
        let nsb = NoteStyleBoard(frame: self.drawingArea.frame)
        nsb.delegate = self
        self.view.addSubview(nsb)
    }
    func changeNoteStyle(_ imgNamed: NoteStyle) {
        self.noteData.eraserImage = imgNamed
        self.drawingArea.setupEraserAs(imgNamed.rawValue)
        
    }
    // MARK: DONE (BACK TO BOARD-VIEW-CONTROLLER)
    
    @IBAction func doneButtonIsClicked() {
        noteData.image = drawingArea.image!
        dataSource?.getNoteData(noteData: noteData, collectionViewIndex: indexOnBoard)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


