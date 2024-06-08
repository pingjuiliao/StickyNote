//
//  BoardViewController.swift
//  StickyNotes
//
//  Created by pingRuiLiao on 2017/10/17.
//  Copyright © 2017年 pingRuiLiao. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, NoteDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    

    @IBOutlet weak var wallpaper: UIImageView!
    
    @IBOutlet weak var trashCanButton: UIButton!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var board: UIImageView!
    var notes : [NoteData] = []
    var noteUpdated: NoteData? = nil

    @IBOutlet weak var trashCanButtonOutlet: UIButton!
    @IBOutlet weak var noteCollection: UICollectionView!
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileNameInBundle.NoteDataFile.asBundlePath())
        self.autolayout()
        self.readAllNotesBackend()
        self.noteCollection.delegate = self
        self.noteCollection.dataSource = self
        self.noteCollection.backgroundColor = .clear
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(BoardViewController.handleLongGesture(gesture:)))
        
        self.noteCollection.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noteCollection.reloadData()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.view.backgroundColor = .black
        return UIStatusBarStyle.lightContent
    }

    
    // MARK: CREATE
    
    @IBAction func buttonAddNewStickyNote(_ sender: Any) {
        self.deletionMode = false
        if let nvc = self.storyboard?.instantiateViewController(withIdentifier: "noteViewController") as? NoteViewController {
            nvc.indexOnBoard = self.notes.count
            nvc.dataSource = self
            present(nvc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: READ & UPDATE (collectionview.cell.addTarget(...))
    @objc func editANote(_ cellTapped: NoteCell) {
        if (deletionMode) {
            self.removeCellAt(index: cellTapped.tag)
            return
        }
        guard let nvc = storyboard?.instantiateViewController(withIdentifier: "noteViewController") as? NoteViewController else {
            return
        }
        nvc.dataSource = self
        nvc.indexOnBoard = cellTapped.tag
        nvc.noteData = self.notes[cellTapped.tag]
        nvc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        nvc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(nvc, animated: true, completion: nil)
        
    }

    // MARK: DELETE
    
    func removeCellAt(index row: Int) {
        self.notes.remove(at: row)
        
        let fileManager = FileManager.default
        let numStr: String = {
            
            if notes.count >= 10 {
                return "\(notes.count)"
            } else {
                return "0"+"\(notes.count)"
            }
        }()
        let fileGonnaDelete =  FileNameInBundle.NotesImagePrefix.asBundlePath() + numStr + ".png"
        do {
            print("remove file named \(fileGonnaDelete)")
            try fileManager.removeItem(atPath: fileGonnaDelete)
        } catch _ {
            print("couldn't remove!!!!!!! ")
        }
        self.noteCollection.reloadData()
        self.writeAllNotesBackend()
        
        self.deletionMode = false
    }
    
    
    
    @IBAction func trashCanButtonIsTapped (_ sender: Any) {
        self.deletionMode = !self.deletionMode
    }
    var deletionMode: Bool = false {
        
        didSet {
            
            if (deletionMode) {
                self.noteCollection.isScrollEnabled = false
                self.wobblingEffect()
                self.trashCanButtonOutlet.setImage(UIImage(named:"trashCanWithSpark"), for: UIControlState())
            } else {
                self.noteCollection.isScrollEnabled = true
                for cell in self.noteCollection.visibleCells {
                    cell.layer.removeAnimation(forKey: "cell rotation")
                }
                
                self.trashCanButtonOutlet.setImage(UIImage(named: "trashCan"), for: UIControlState())
            }
            
        }
    }
    
    func wobblingEffect () {
//        CATransaction.begin() // CATrasaction is to controll a callback event for
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.autoreverses = true
        rotateAnimation.repeatCount = .infinity
        rotateAnimation.fromValue = CGFloat(-0.05)
        rotateAnimation.toValue = CGFloat(0.05)
        rotateAnimation.duration = 0.1
        for cell in self.noteCollection.visibleCells {
            cell.layer.add(rotateAnimation, forKey: "cell rotation")
        }
//        CATransaction.commit()
        
        
    }
    

    // MARK: COLLECTION VIEW
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = noteCollection.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
        cell.noteImage.image = notes[indexPath.row].image
        cell.button.addTarget(self, action:#selector(BoardViewController.editANote(_:)) , for: UIControlEvents.touchUpInside)
        cell.button.tag = indexPath.row
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
    // MARK: NoteDataSource
    func getNoteData(noteData data: NoteData, collectionViewIndex index: Int) {
        if (index >= self.notes.count) {
            self.notes.append(data)
        } else {
            self.notes[index] = data
        }
        self.writeAllNotesBackend()
    }
    
    // MARK: REORDER-ABLE -- LONG PRESS AND DRAG THE NOTE(CELL)
    
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let notedata = self.notes.remove(at: sourceIndexPath.row)
//        self.notes.insert(notedata, at: destinationIndexPath.row)
//        writeAllNotesBackend()
//    }
    
    // MARK: Delete
    @objc func handleLongGesture(gesture:
        UILongPressGestureRecognizer) {
        self.deletionMode = false
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.noteCollection.indexPathForItem(at: gesture.location(in: self.noteCollection)) else {
                break
            }
            self.noteCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            self.noteCollection.updateInteractiveMovementTargetPosition(gesture.location(in:gesture.view!))
        case UIGestureRecognizerState.ended:
            self.noteCollection.endInteractiveMovement()
            self.writeAllNotesBackend()
        default:
            self.noteCollection.cancelInteractiveMovement()
        }
    }
    
    // MARK: BACKEND : READ & WRITE
    func readAllNotesBackend() {
        
        // OLD CODE
        let fileManager = FileManager.default
        //let directoryPath = "\(NSHomeDirectory())/Documents/Notes"
        var erasers: [String] = []
        if let allFiles = (try? fileManager.contentsOfDirectory(atPath: FileNameInBundle.DirectoryOfNoteData.asBundlePath())) {
            // NoteData._eraserOfImagePath (step.1)
            let eraserStringFile = FileNameInBundle.NoteDataFile.asBundlePath()
            guard fileManager.fileExists(atPath: eraserStringFile) else {
                return
            }
            let content = try? String(contentsOfFile: eraserStringFile, encoding: String.Encoding.utf8)
            erasers = content!.components(separatedBy: "\n") // input eraser array
            print("erasers count : \(erasers.count)")
            // NoteData._note (step.2)
//            var eraserIndex = 0
            for i in 1...erasers.count { // 1-based
                let filename: String = {
                    if i >= 10 {
                        return FileNameInBundle.NotesImagePrefix.rawValue + "\(i).png"
                    } else {
                        return FileNameInBundle.NotesImagePrefix.rawValue + "0\(i).png"
                        // Why 1-based ? 0-based file xxx00 will not read first
                    }
                }()
                let filepath = "\(NSHomeDirectory())/Documents/Notes/\(filename)"
                let imageData = try? Data(contentsOf: URL(fileURLWithPath: filepath))
                let image = UIImage(data: imageData!)
                self.notes.append(NoteData(note_style_image: image!, eraserImageNamed: erasers[i-1].toNoteAvailable()))
                
            }
//            for file in allFiles {
//                print(file)
//                if file.range(of: FileNameInBundle.NotesImagePrefix.rawValue, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil {
//                    let filePath = "\(NSHomeDirectory())/Documents/Notes/\(file)"
//                    let imageData = try? Data(contentsOf: URL(fileURLWithPath: filePath))
//                    let image = UIImage(data: imageData!)
//                    self.notes.append(NoteData(note_style_image: image!, eraserImageNamed: erasers[eraserIndex].toNoteAvailable()))
//                    eraserIndex += 1
//                }
//
//            }
        }
    }
    func writeAllNotesBackend() {

        //OLD CODE
        let queue = DispatchQueue.global()
        queue.async {
            var eraserString = ""
            let list = [Int](0...self.notes.count-1) // 0-based

            for index in list {
                let numString: String = {
                    if index+1 >= 10 {
                        return "\(index+1)"
                    } else {
                        return "0" + "\(index+1)"
                        // Why 1-based ? 0-based file xxx00 will not read first
                    }
                }()
                let fileManager = FileManager.default
                let objId = FileNameInBundle.NotesImagePrefix.rawValue + numString + ".png"
                let directoryPath = FileNameInBundle.DirectoryOfNoteData.asBundlePath()
                let noteImageBundlePath = directoryPath + "/\(objId)"
                if !fileManager.fileExists(atPath: directoryPath) {
                    do {
                        try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
                    } catch _ {
                        //
                    }
                }
                // write a image
                try? UIImagePNGRepresentation(self.notes[index].image)!.write(to: URL(fileURLWithPath: noteImageBundlePath)  , options: [.atomic])
                // write json file
                if index == 0 {
                    eraserString += self.notes[index].eraserImage.rawValue
                } else {
                    eraserString += "\n" + self.notes[index].eraserImage.rawValue
                }

            }
            // write eraser string

            try? eraserString.write(toFile: FileNameInBundle.NoteDataFile.asBundlePath(), atomically: true, encoding: String.Encoding.utf8)



        }
        
        
    }
    // MARK: autolayout
    func autolayout() {
        // setup
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        self.view.bounds = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        // wallpaper
//        self.wallpaper.bounds = UIScreen.main.bounds
//        print(wallpaper.bounds)
        // board
        let boardY = 57.0/736.0 * h
        let boardWidth = 340.0/414.0 * w
        let boardHeight = 550.0/736.0 * h
        let boardX = ( w - boardWidth ) / 2.0
        self.board.bounds = CGRect(x: boardX, y: boardY, width: boardWidth, height: boardHeight)
        // collectionView
        // (should be matched with self.board)
        let collectionViewX = 57.0/414.0 * w
        let collectionViewY = 76.0/736.0 * h
        let collectionViewWidth = 300.0/414.0 * w
        let collectionViewHeight = 512.0/736.0 * h
        self.noteCollection.bounds = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewWidth, height: collectionViewHeight)
        
        // new note button
        let buttonFrame = CGSize(width: 85.0, height: 85.0)
        
        let newNoteOrigin = CGPoint(x: 57.0/414.0 * w, y:624.0/736.0 * h)
        self.newNoteButton.bounds = CGRect(origin: newNoteOrigin, size: buttonFrame)
        
        // trash can button
        let trashCanOrigin = CGPoint(x: 230.0/414.0 * w, y: 620.0/736.0 * h)
        self.trashCanButton.bounds = CGRect(origin: trashCanOrigin, size: buttonFrame)
        
        
    }
    
    
}

extension BoardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = 90.0/300.0 * self.noteCollection.bounds.width
        let h = 90.0/512.0 * self.noteCollection.bounds.height
        return CGSize(width: w, height: h)
    }
}
