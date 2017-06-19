//
//  GraphicsElement.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import Foundation
import CoreGraphics

//enum GraphicsElementType: String {
//    case astrolabe, bat, catalog,
//    comet, constellation, crystal,
//    globe, lens, meteorite, microcosm,
//    nebula, prism, ruler, scorpion, valve
//}

struct GraphicsElement {
//    var type        : GraphicsElementType?
    var type        = ""
    var position    = ""
    var coordinates : CGPoint!
    var name        = ""
}
