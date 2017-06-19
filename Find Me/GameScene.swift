//
//  GameScene.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK:- Private variables
    fileprivate var data: GraphicsElements!
    fileprivate var firstSortedGraphicsElements : [GraphicsElement] = []
    fileprivate var secondSortedGraphicsElements: [GraphicsElement] = []
    fileprivate var parser                      = MyXMlParser.shared
    fileprivate var loc                         :CGPoint!
    fileprivate var element                     :SKSpriteNode!
    fileprivate var elementTexture              :SKTexture!
    fileprivate var button                      :SKLabelNode!
    fileprivate var nameOfObject                :SKLabelNode!
    fileprivate var count                       = 0
    fileprivate var y                           = 0
    fileprivate var timer                       = 0
    fileprivate var gameOver                    :SKLabelNode!
    fileprivate var check                       = true
    fileprivate var disappear                   :SKAction!
    fileprivate var workObject                  = SKNode()
    fileprivate var labelObject                 = SKNode()
    fileprivate var arrayOfTextures             : [SKTexture] = []
    fileprivate var arrayOfWorkObject           : [SKSpriteNode] = []
    fileprivate var arrayOfLabels               : [SKLabelNode] = []
    fileprivate var arrayOfIndex                : [Int] = []
    
    // MARK:- SKScene methods
    override func didMove(to view: SKView) {
        disappear = SKAction.fadeOut(withDuration: 2)
        parser.parserxml()
        data = GraphicsElements(background: parser.background,
                                graphicsElements: parser.graphicsElements)
        addBackground()
        addButtonNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            loc = touch.location(in:self)
            if !arrayOfWorkObject.isEmpty{
                for i in 0 ..< arrayOfWorkObject.endIndex {
                    if !arrayOfWorkObject.isEmpty && arrayOfWorkObject[i].contains(loc) && arrayOfLabels[i].alpha != 0{
                        arrayOfWorkObject[i].run(disappear)
                        arrayOfLabels[i].alpha = 0
                        count += 1
                        timer = 0
                    }
                }
            }
            
            // Нажимаем на кнопку новая игра
            
            if button.contains(loc){
                scene?.removeAllChildren()
                createGame()
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Анимация дрожания
        let rotationOne = SKAction.rotate(byAngle: CGFloat(Double.pi/18), duration: 0.05)
        let rotationTwo = SKAction.rotate(byAngle: CGFloat(-Double.pi/9), duration: 0.05)
        let rotationThree = SKAction.rotate(byAngle: CGFloat(Double.pi/18), duration: 0.05)
        let sequence = SKAction.sequence([rotationOne, rotationTwo, rotationThree])
        var countOne = 0
        timer += 1
        if timer == 600{
            if !arrayOfWorkObject.isEmpty{
                countOne = 0
                for i in 0 ..< arrayOfWorkObject.endIndex{
                    if arrayOfLabels[i].alpha != 0 && countOne == 0 {
                        arrayOfWorkObject[i].run(SKAction.repeat(sequence, count: 3))
                        countOne = 1
                    }
                }
            }
        }
        if timer > 600{
            timer = 0
        }
        if count == 5{
            scene?.removeAllChildren()
            self.addChild(button)
            gameOver = SKLabelNode(fontNamed: "TimesNewRomanPSMT")
            gameOver.fontSize = 40
            gameOver.fontColor = SKColor.white
            gameOver.text = "GAME OVER"
            gameOver.position = CGPoint(x: 360, y: -320)
            self.addChild(gameOver)
        }
    }
}

// MARK:- Private methods
private extension GameScene {
    // Метод который задаёт фон
    func addBackground(){
        let backgroundTexture = SKTexture(imageNamed: data.background)
        let background = SKSpriteNode(texture: backgroundTexture)
        background.anchorPoint = CGPoint(x: 0, y: 1)
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: 720, height: 640)
        background.zPosition = -1
        self.addChild(background)
    }
    
    // Метод который добавляет не рабочие элементы
    
    func addElement(element:GraphicsElement){
        let elementsTexture = SKTexture(imageNamed: element.name)
        let elements = SKSpriteNode(texture: elementsTexture)
        elements.position = element.coordinates!
        elements.anchorPoint = CGPoint(x: 0, y: 1)
        workObject.addChild(elements)
    }
    
    // Метод который добавляет кнопку новая игра
    
    func addButtonNewGame(){
        button = SKLabelNode(fontNamed: "TimesNewRomanPSMT")
        button.position = CGPoint(x: 90, y: -630)
        button.fontSize = 30
        button.text = "New Game"
        button.fontColor = SKColor.red
        self.addChild(button)
    }
    
    // Метод который получает необходимые данные сортируя наш массив
    
    func getSortedData(){
        firstSortedGraphicsElements = SortGraphicsElements.firstSort(of: data.graphicsElements)
        secondSortedGraphicsElements = SortGraphicsElements.secondSort(of: firstSortedGraphicsElements)
    }
    
    // Метод который добавляет все элементы на поле
    
    func addWorkElements (){
        self.addChild(workObject)
        self.addChild(labelObject)
    }
    
    // Метод который создаёт игру
    
    func createGame (){
        createObjectForGame()
        //        arrayOfWorkObjectCopy = arrayOfWorkObject
        addWorkElements()
        timer = 0
    }
    
    // Метод который создаёт игровые элементы
    
    func createObjectForGame (){
        getSortedData()
        addBackground()
        addButtonNewGame()
        arrayOfLabels.removeAll()
        arrayOfWorkObject.removeAll()
        arrayOfTextures.removeAll()
        workObject.removeAllChildren()
        labelObject.removeAllChildren()
        
        count = 0
        y = -20
        
        // Добавление остальных не активных элементов
        
        for i in 0 ..< firstSortedGraphicsElements.endIndex{
            check = true
            for j in 0 ..< secondSortedGraphicsElements.endIndex{
                if secondSortedGraphicsElements[j].type == firstSortedGraphicsElements[i].type {
                    check = false
                }
            }
            if check {
                addElement(element: firstSortedGraphicsElements[i])
            }
        }
        // Создание активных элементов
        
        for i in 0 ..< secondSortedGraphicsElements.endIndex {
            elementTexture = SKTexture(imageNamed: secondSortedGraphicsElements[i].name)
            arrayOfTextures.append(elementTexture)
            element = SKSpriteNode(texture: elementTexture)
            element.anchorPoint = CGPoint(x: 0, y: 1)
            element.position = secondSortedGraphicsElements[i].coordinates!
            arrayOfWorkObject.append(element)
            workObject.addChild(arrayOfWorkObject[i])
            print(secondSortedGraphicsElements[i].coordinates)
        }
        
        // Создаём имена элементов которые нужно найти
        
        for i in 0 ..< secondSortedGraphicsElements.endIndex{
            nameOfObject = SKLabelNode(fontNamed: "TimesNewRomanPSMT")
            nameOfObject.position = CGPoint(x: 55, y: y)
            nameOfObject.fontSize = 20
            nameOfObject.text = "\(secondSortedGraphicsElements[i].type)"
            nameOfObject.fontColor = SKColor.red
            arrayOfLabels.append(nameOfObject)
            labelObject.addChild(arrayOfLabels[i])
            y -= 20
        }
    }
    
    // вызываем функцию когда нажимаем на экран
    
    // Обновляем сцену
}
