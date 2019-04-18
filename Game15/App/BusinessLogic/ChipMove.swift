//
//  ChipMove.swift
//  Game15
//
//  Created by Dinar Ilalov on 17/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import Foundation

struct ChipMove {
    let numbers: [Int]
    let moveDirection: AvailableMoveDirection
    var chipModels: [ChipModel] = []
    var chipViews: [ChipView] = []
    
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
}
