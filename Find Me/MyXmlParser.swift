//
//  Parser.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import Foundation
import CoreGraphics

enum FileExtensions {
    static let xml = "xml"
}

class MyXmlParser: NSObject {
    
    // MARK:- Public variables
    static let shared = MyXmlParser()
    
    public var background  = ""
    public var graphicsElements: [GraphicsElement] = []
    
    // MARK:- Private variables
    fileprivate var type        = ""
    fileprivate var element     = ""
    fileprivate var position    = ""
    fileprivate var name        = ""
    fileprivate var coordinates : CGPoint?
    
    public func parserxml(){
        if let path: URL = Bundle.main.url(forResource: "config",
                                           withExtension: FileExtensions.xml) {
            let parser = XMLParser(contentsOf: path)
            parser?.delegate = self
            parser?.parse()
        }
    }
}

// MARK:- XMLParserDelegate
extension MyXmlParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName
        switch elementName {
        case "item":
            if let type = attributeDict ["type"]{
                self.type = type
            }
            if let position = attributeDict["position"] {
                self.position = position
            }
            var floatX: CGFloat?
            var floatY: CGFloat?
            
            if let x = attributeDict["x"], let cgX = Int(x) {
                floatX = CGFloat(cgX)
            }
            
            if let y = attributeDict["y"], let cgY = Int(y) {
                floatY = -CGFloat(cgY)
            }
            
            if let floatX = floatX, let floatY = floatY {
                coordinates = CGPoint(x: floatX,
                                      y: floatY)
            }
            
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch element {
        case "background":
            background = string
            background = background.replacingOccurrences(of: "assets/", with: "")
        case "item":
            if name.isEmpty {
                name = string
                name = name.replacingOccurrences(of: "\n", with: "")
                name = name.replacingOccurrences(of: "\t", with: "")
                name = name.replacingOccurrences(of: "assets/", with: "")
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "item":
            let graphicsElement = GraphicsElement(type        : type,
                                                  position    : position,
                                                  coordinates : coordinates,
                                                  name        : name)
            graphicsElements.append(graphicsElement)
            
        default:
            break
        }
        element = ""
        name    = ""
    }
}
