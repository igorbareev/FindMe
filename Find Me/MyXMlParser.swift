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

class MyXMlParser: NSObject, XMLParserDelegate  {
    
    static let shared = MyXMlParser() // синглтон
    
    var parser: XMLParser! // Так мы просто объявляем переменную конкретного класса без инициализации,
    var graphicsElements: [GraphicsElement] = [] {        // Так мы создаем пустой массив
        didSet {
//            let index = graphicsElements.endIndex - 1
////            print("graphicsElement[\(index)]:  Перечисление параметров: type = \(graphicsElements[index].type!) position = \(graphicsElements[index].position) coordinates = \(graphicsElements[index].coordinates!)  name = \(graphicsElements[index].name))")
        }
    }
    
    var element                = "" // Наш элемент который сохраняет теги!
    var position               = ""
    var name                   = ""
    var background             = ""
    var coordinates : CGPoint?
    var type                   = ""
//    var type        : GraphicsElementType?
    
    func parserxml(){
        // Если создается URL путь нашего xml файла в проекте
        if let path: URL = Bundle.main.url(forResource: "config", withExtension: FileExtensions.xml) {
            // заходим в тело лог выражения
            // создаем экземпляр переменной класса XMLParser, т.е. ее инициализируем
            let parser = XMLParser(contentsOf: path)
            // Говорим что наш класс MyXMlParser - реализует методы делегата протокола XMLParserDelegate
            parser?.delegate = self
            // Говорим нашему парсеру начинать парсинг, то есть он начнет вызывать методы делега что описаны ниже
            parser?.parse()
        }
        
    }
    
    // Методы нашего XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName // Здесь мы наткнулись на тег и его запомнили!
        
        if elementName == "item" { // Здесь проверка на тег (какой тег мы сейчас смотрим)
            // Tут мы в теге item и если там есть параметры по тем ключам что мы ищем то записываем их в наши глобальные переменные
            if let _type = attributeDict ["type"]{
//                let graphicsElementType = GraphicsElementType(rawValue: _type) {
                type = _type
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
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Здесь тега нет тут только данные в теле тега!
        if element == "background" {
            background = string
            background = background.replacingOccurrences(of: "assets/", with: "")
            
        }
        else if element == "item" {
            if name.isEmpty {
                name = string
                name = name.replacingOccurrences(of: "\n", with: "")
                name = name.replacingOccurrences(of: "\t", with: "")
                name = name.replacingOccurrences(of: "assets/", with: "")
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // Мы дошли до закрытого тега
        // Надо создать элемент GraphicsElemnt и засунуть в наш массив элементов
        
        if elementName == "item" {
            let graphicsElement = GraphicsElement(type        : type,
                                                  position    : position,
                                                  coordinates : coordinates,
                                                  name        : name)
            graphicsElements.append(graphicsElement)
            
        }
        // Здесь надо наш тег обнулить и обнуляем тело в теге
        element = ""
        name    = ""
    }
}
