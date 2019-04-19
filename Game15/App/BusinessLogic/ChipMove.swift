//
//  ChipMove.swift
//  Game15
//
//  Created by Dinar Ilalov on 17/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

struct ChipMove {
    let numbers: [Int]
    let moveDirection: AvailableMoveDirection
    var chipModels: [ChipModel] = []
    var chipViews: [ChipView] = []
    
    var chipWidth: CGFloat = 0
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    
    var finalPoint: CGPoint = .zero
    
    init(numbers: [Int], moveDirection: AvailableMoveDirection) {
        self.numbers = numbers
        self.moveDirection = moveDirection
    }
    
    mutating func setModels(allModels: [ChipModel]) {
        for number in numbers {
            let model = allModels.first { $0.number == number }
            if model != nil {
                chipModels.append(model!)
            }
        }
    }
    
    mutating func setViewsToMove(allViews: [ChipView]) {
        
        for model in chipModels {
            let view = allViews.first { $0.chipModel === model }
            if view != nil {
                chipViews.append(view!)
            }
        }
    }
    
    mutating func setMovePoints(with chipView: ChipView) {
        startPoint = chipView.center
        
        switch moveDirection {
        case .down:
            endPoint = CGPoint(x: startPoint.x, y: startPoint.y + CGFloat(chipWidth))
        case .up:
            endPoint = CGPoint(x: startPoint.x, y: startPoint.y - CGFloat(chipWidth))
        case .right:
            endPoint = CGPoint(x: startPoint.x + CGFloat(chipWidth), y: startPoint.y)
        case .left:
            endPoint = CGPoint(x: startPoint.x - CGFloat(chipWidth), y: startPoint.y)
        case .none:
            break
        }
    }
    
    func move(with translation: CGPoint) {
        for (chipIndex, view) in chipViews.enumerated() {
            moveChipView(view, chipIndex: CGFloat(chipIndex), translation: translation)
        }
    }
    
    mutating func endMove() {
        
        let chipView = chipViews[0]
        
        //var finalPoint: CGPoint
        switch moveDirection {
        case .down:
            if chipView.center.y > endPoint.y - CGFloat(chipWidth)/2 {
                finalPoint = endPoint
            } else {
                finalPoint = startPoint
            }
            
        case .up:
            if chipView.center.y < endPoint.y + CGFloat(chipWidth)/2 {
                finalPoint = endPoint
            } else {
                finalPoint = startPoint
            }
        case .right:
            if chipView.center.x > endPoint.x - CGFloat(chipWidth)/2 {
                finalPoint = endPoint
            } else {
                finalPoint = startPoint
            }
        case .left:
            if chipView.center.x < endPoint.x + CGFloat(chipWidth)/2 {
                finalPoint = endPoint
            } else {
                finalPoint = startPoint
            }
        default:
            return
        }
        
    }
    
    func moveChipView(_ chipView: ChipView, chipIndex: CGFloat, translation: CGPoint) {
        
        switch moveDirection {
        case .down:
            if chipView.center.y + translation.y > endPoint.y + chipWidth*chipIndex {
                chipView.center = CGPoint(x: endPoint.x,
                                          y: endPoint.y + chipWidth*chipIndex)
            } else if chipView.center.y + translation.y < startPoint.y + chipWidth*chipIndex {
                chipView.center = CGPoint(x: startPoint.x,
                                          y: startPoint.y + chipWidth*chipIndex)
            } else {
                chipView.center = CGPoint(x: chipView.center.x,
                                          y: chipView.center.y + translation.y)
            }
        case .up:
            if chipView.center.y + translation.y < endPoint.y - chipWidth*chipIndex {
                chipView.center = CGPoint(x: endPoint.x,
                                          y: endPoint.y - chipWidth*chipIndex)
            } else if chipView.center.y + translation.y > startPoint.y - chipWidth*chipIndex {
                chipView.center = CGPoint(x: startPoint.x,
                                          y: startPoint.y - chipWidth*chipIndex)
            } else {
                chipView.center = CGPoint(x: chipView.center.x,
                                          y: chipView.center.y + translation.y)
            }
        case .right:
            if chipView.center.x + translation.x > endPoint.x + chipWidth*chipIndex {
                chipView.center = CGPoint(x: endPoint.x + chipWidth*chipIndex,
                                          y: endPoint.y)
            } else if chipView.center.x + translation.x < startPoint.x + chipWidth*chipIndex {
                chipView.center = CGPoint(x: startPoint.x + chipWidth*chipIndex,
                                          y: startPoint.y)
            } else {
                chipView.center = CGPoint(x: chipView.center.x + translation.x,
                                          y: chipView.center.y)
            }
        case .left:
            if chipView.center.x + translation.x < endPoint.x - chipWidth*chipIndex {
                chipView.center = CGPoint(x: endPoint.x - chipWidth*chipIndex,
                                          y: endPoint.y)
            } else if chipView.center.x + translation.x > startPoint.x - chipWidth*chipIndex {
                chipView.center = CGPoint(x: startPoint.x - chipWidth*chipIndex,
                                          y: startPoint.y)
            } else {
                chipView.center = CGPoint(x: chipView.center.x + translation.x,
                                          y: chipView.center.y)
            }
        default:
            break
        }
    }
}
