//
//  Sorted.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import Foundation
class SortGraphicsElements {
    static func firstSort(of graphicsElements: [GraphicsElement]) -> [GraphicsElement] {
        var finalArrayOfGraphicsElements: [GraphicsElement] = []
        var typeOfGraphicsElements: [GraphicsElement] = []
        var count = 0
        
        for i in 0 ..< graphicsElements.endIndex {
            let type = graphicsElements[i].type
            typeOfGraphicsElements.append(graphicsElements[i])
            for j in i+1 ..< graphicsElements.endIndex{
                if !finalArrayOfGraphicsElements.isEmpty{
                    for z in 0 ..< finalArrayOfGraphicsElements.endIndex{
                        if finalArrayOfGraphicsElements[z].type == type  {
                            count += 1
                        }
                    }
                }
                if  count == 0 && graphicsElements[j].type == type {
                    typeOfGraphicsElements.append(graphicsElements[j])
                }
            }
            if count == 0 {
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
