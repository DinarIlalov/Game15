//
//  Game.swift
//  Game15
//
//  Created by Dinar Ilalov on 10/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

class Game {
    
    static let gameGridCount = 4
    
    var field: ChipsMatrix
    var chips: [ChipModel] = []
    
    var isDone: Bool = false
    
    init() {
        field = ChipsMatrix(rowsCount: Game.gameGridCount, columnsCount: Game.gameGridCount)
    }
    
    func new() {
        chips.removeAll()
        field.reset()
        for rowIndex in (0..<Game.gameGridCount) {
            for columnIndex in (0..<Game.gameGridCount) {
                
                let chip = ChipModel(number: field[rowIndex, columnIndex],
                                     placeInMatrix: MatrixCoordinate(rowIndex: rowIndex, columnIndex: columnIndex))
                chips.append(chip)
            }
        }
    }
    
    func canMoveChip(_ chip: ChipModel) -> AvailableMoveDirection {
        return field.canMoveToZero(from: chip.placeInMatrix)
    }
    
    func moveChipToZero(_ chip: ChipModel) {
        
        let zeroChip = chips.first { $0.number == 0 }
        zeroChip?.placeInMatrix = chip.placeInMatrix
        
        chip.placeInMatrix = field.moveToZeroValue(from: chip.placeInMatrix)
        
        checkGameIsDone()
    }
    
    private func checkGameIsDone() {
        
        self.isDone = field.chips.elementsEqual([[1,2,3,4],
                                                 [5,6,7,8],
                                                 [9,10,11,12],
                                                 [13,14,15,0]])
        
    }
}
