//
//  GraphicsElements.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import Foundation

class GraphicsElements {
    var background = ""
    var graphicsElements: [GraphicsElement] = []
    
    init(background: String, graphicsElements: [GraphicsElement]) {
        self.background       = background
        self.graphicsElements = graphicsElements
    }
}
