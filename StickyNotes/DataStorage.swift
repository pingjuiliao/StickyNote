//
//  DataStorage.swift
//  StickyNotes
//
//  Created by pingRuiLiao on 2017/10/18.
//  Copyright © 2017年 pingRuiLiao. All rights reserved.
//

import Foundation
struct NoteJson {
    var filename: String
    var text: String
    var eraser: NoteStyle
}

enum BackendError {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
