//
//  Sorted.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import Foundation
class SortGraphicsElements {
    // static означает что это метод класса, а не экземпляра класса. Это удобно для того что нам надо просто провести операцию и все без использования
    // в дальнейшим экземпляра элемента класса
    static func firstSort(of graphicsElements: [GraphicsElement]) -> [GraphicsElement] {
        var finalArrayOfGraphicsElements: [GraphicsElement] = []
        var typeOfGraphicsElements: [GraphicsElement] = []
        var count = 0
        
        for i in 0 ..< graphicsElements.endIndex {                     // идём по массиву первый раз
            let type = graphicsElements[i].type                         // присваиваем тип первого элемента, переменной
            typeOfGraphicsElements.append(graphicsElements[i])          // записываем элемент с таким типом в массив типов
            for j in i+1 ..< graphicsElements.endIndex{                // идём по массиву второй раз
                if !finalArrayOfGraphicsElements.isEmpty{              // проврка не пустой ли у нас конечный массив
                    for z in 0 ..< finalArrayOfGraphicsElements.endIndex{  // идём по финальному массиву если он не пустой
                        if finalArrayOfGraphicsElements[z].type == type  { // если тип элемента под z индексу равен типу который сейчас у нас то значит такой тип уже записан в конечный массив
                            count += 1                                  // увеличиваем счётчик на 1
                        }
                    }
                }
                if  count == 0 && graphicsElements[j].type == type { // если счётчик 0(значит что такого типа не встречалось) и тип элемента с индексом j равен запомненному типу то
                    typeOfGraphicsElements.append(graphicsElements[j])  // записываем элемент в массив типов
                }
            }
            if count == 0{
                let t = arc4random_uniform(UInt32(typeOfGraphicsElements.count))
                finalArrayOfGraphicsElements.append(typeOfGraphicsElements[Int(t)])
            }
            typeOfGraphicsElements.removeAll()
            count = 0
        }
        return finalArrayOfGraphicsElements
    }
    
    static func secondSort (of graphicsElements:[GraphicsElement]) -> [GraphicsElement]{
        var finalArrayOfGraphicsElements:[GraphicsElement] = []
        var arrayOfIndex:[Int] = []
        var count              = 0
        var index              = 0
        var newCount           = 0
        
        while count < 5 {
            index = Int(arc4random_uniform(UInt32(graphicsElements.count)))
            if arrayOfIndex.isEmpty{
                arrayOfIndex.append(index)
                count += 1
            }else{
                for i in 0 ..< arrayOfIndex.endIndex{
                    if arrayOfIndex[i] == index {
                        newCount += 1
                    }
                }
                if newCount == 0 {
                    arrayOfIndex.append(index)
                    count += 1
                }
                newCount = 0
            }
        }
        for j in 0 ..< arrayOfIndex.endIndex{
            finalArrayOfGraphicsElements.append(graphicsElements[arrayOfIndex[j]])
        }
        return finalArrayOfGraphicsElements
    }
}
