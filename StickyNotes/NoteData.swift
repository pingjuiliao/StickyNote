//
//  NoteData.swift
//  AdhesiveNote
//
//  Created by pingRuiLiao on 2016/3/31.
//  Copyright © 2016年 pingRuiLiao. All rights reserved.
//


import Foundation
import UIKit


struct NoteData {
//    var filename: String
    var image: UIImage
    var eraserImage: NoteStyle
    
    init() {
        image = UIImage(named: "noteYellow")!
        eraserImage = NoteStyle.yellow
    }
    init(note_style_image: UIImage, eraserImageNamed eraser: NoteStyle) {
        image = note_style_image
        eraserImage = eraser
    }
}

enum FileNameInBundle: String {
    case DirectoryOfNoteData = "Notes"
    case NotesImagePrefix = "NoteImage"
    case NoteDataFile =  "NoteData.txt"
    func asBundlePath() -> String {
        
        switch(self) {
        case .DirectoryOfNoteData:
            return "\(NSHomeDirectory())/Documents/Notes"
        case .NotesImagePrefix:
            return "\(NSHomeDirectory())/Documents/Notes/NoteImage"
        case .NoteDataFile:
            return "\(NSHomeDirectory())/Documents/Notes/NoteData.json"
            
        }
    }
}

extension String {
    func toNoteAvailable() -> NoteStyle {
        switch(self) {
        case "noteYellow":
            return .yellow
        case "noteRed":
            return .red
        case "noteBlue":
            return .blue
        case "noteTexty":
            return .texty
        default:
            return .yellow
        }
    }
}
