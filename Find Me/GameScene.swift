//
//  GameScene.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import SpriteKit
import GameplayKit

fileprivate let kFadeDuration: TimeInterval = 0.43

// TODO:- В конце добавить у надписи Game Over эффекты конфити или еще что-то в этом роде.
// TODO:- Сделать анимацию распределения элементов с прокруткой их на свое место. 
// TODO:- Идея такая: Реализовать анимацию появления всех элементов из центральной точки сцены их распределения по своим координатам
// TODO:- Распределние сделать не по прямой а по изогнутой кривой. Смотри UIBezierPath и CAKeyFrameAnimation, CACoreAnimation. Возможно реализуй через SpriteKit

class GameScene: SKScene {
    // MARK:- Private variables
    fileprivate var data: GraphicsElements!
    fileprivate var firstSortedGraphicsElements : [GraphicsElement] = []
    fileprivate var secondSortedGraphicsElements: [GraphicsElement] = []
    fileprivate var parser                      = MyXmlParser.shared
    fileprivate var loc                         :CGPoint!
    fileprivate var element                     :SKSpriteNode!
    fileprivate var elementTexture              :SKTexture!
    fileprivate var button                      :SKLabelNode!
    fileprivate var nameOfObject                :SKLabelNode!
    fileprivate var gameOver                    :SKLabelNode!
    fileprivate var count                       = 0
    fileprivate var y                           = 0
    fileprivate var timer                       = 0
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
        disappear = SKAction.fadeOut(withDuration: kFadeDuration)
        parser.parserxml()
        data = GraphicsElements(background: parser.background,
                                graphicsElements: parser.graphicsElements)
        addBackground()
        addButtonNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // MARK:- Оптимизировать !arrayOfWorkObject.isEmpty - дважды проверяется - не очень хорошо.
            loc = touch.location(in:self)
            if !arrayOfWorkObject.isEmpty {
                for i in 0 ..< arrayOfWorkObject.endIndex {
                    if !arrayOfWorkObject.isEmpty && arrayOfWorkObject[i].contains(loc) && arrayOfLabels[i].alpha != 0 {
                        arrayOfWorkObject[i].run(disappear)
                        arrayOfLabels[i].alpha = 0
                        count += 1
                        timer = 0
                    }
                }
            }
            
            // FIXME:- loc - плохое название. Тяжело читается и не понятно. Переделать.
            if button.contains(loc) {
                scene?.removeAllChildren()
                createGame()
            }
        }
    }
    
    
    // FIXME:- Shake очень сырой. Требуется серьезная доработка. Добавить эффект выжигания.
    override func update(_ currentTime: TimeInterval) {
        // TODO:- оптимизировать. Вынести в отдельный extension у SKAction
        // MARK:- вызов должен выглядить: у элемента дернуть метод .shake()
        // MARK:- Параметры вынести так чтобы можно было их прокидывать т.е чтобы в методе можно опционально задавать параметр duration 
        // MARK:- Пример: func shake(duration: TimeInterval? = 0.05) - по дефолту 0.05 но и можно свой прокинуть будет.
        let rotationOne = SKAction.rotate(byAngle: CGFloat(Double.pi / 18),
                                          duration: 0.05)
        let rotationTwo = SKAction.rotate(byAngle: CGFloat(-Double.pi / 9),
                                          duration: 0.05)
        let rotationThree = SKAction.rotate(byAngle: CGFloat(Double.pi / 18),
                                            duration: 0.05)
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
        if timer > 600 {
            timer = 0
        }
        if count == 5 {
            // TODO:- Вынести в отдельный метод
            // MARK:- Вообще следует большие методы разбивать на логическую цепочку маленьких
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
    func addBackground() {
        let backgroundTexture = SKTexture(imageNamed: data.background)
        let background = SKSpriteNode(texture: backgroundTexture)
        background.anchorPoint = CGPoint(x: 0, y: 1)
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: 720, height: 640)
        background.zPosition = -1
        addChild(background)
    }
    
    func addElement(element:GraphicsElement) {
        let elementsTexture = SKTexture(imageNamed: element.name)
        let elements = SKSpriteNode(texture: elementsTexture)
        elements.position = element.coordinates!
        elements.anchorPoint = CGPoint(x: 0, y: 1)
        workObject.addChild(elements)
    }
    
    func addButtonNewGame() {
        // TODO:- Создать enum в котором хранить данные fontName и использовать
        button = SKLabelNode(fontNamed: "TimesNewRomanPSMT")
        button.position = CGPoint(x: 90, y: -630)
        button.fontSize = 30
        // TODO:- Создать enum со всеми текстами и использовать
        // MARK:- Задавать всякие параметри таким образом очень плохой тон!
        button.text = "New Game"
        button.fontColor = .red
        addChild(button)
    }
    
    func getSortedData() {
        firstSortedGraphicsElements = SortGraphicsElements.firstSort(of: data.graphicsElements)
        secondSortedGraphicsElements = SortGraphicsElements.secondSort(of: firstSortedGraphicsElements)
    }

    func addWorkElements() {
        self.addChild(workObject)
        self.addChild(labelObject)
    }
    

    func createGame() {
        createObjectForGame()
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
        
        // TODO:- Разнести логику по методам слишком много в одном методе. НЕвозможно читать и трудно вносить изменения.
        for i in 0 ..< firstSortedGraphicsElements.endIndex {
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
        
        for i in 0 ..< secondSortedGraphicsElements.endIndex {
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
}
