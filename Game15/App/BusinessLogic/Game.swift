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
    
    
    /// return Available move with chip models and direction
    ///
    /// - Parameter coordinate: selected chip coordinate in ChipsMatrix
    /// - Returns: ChipMove
    func chipsMove(from coordinate: MatrixCoordinate) -> ChipMove {
        var chipMove = field.availableMove(from: coordinate)
        chipMove.setModels(allModels: chips)
        
        return chipMove
    }
    
    
    /// change coordinates in Chip models after move done
    ///
    /// - Parameter chipMove: ChipMove
    func moveChipToZero(_ chipMove: ChipMove) {
        
        var movingCoordinates: [MatrixCoordinate] = []
        
        var zeroCoordinate: MatrixCoordinate = MatrixCoordinate(rowIndex: 0, columnIndex: 0)
        for (modelIndex, model) in chipMove.chipModels.enumerated() {
            movingCoordinates.append(model.placeInMatrix)
            
            if modelIndex == 0 {
                zeroCoordinate = model.placeInMatrix
            } else if modelIndex >= chipMove.chipModels.count-1 {
                model.placeInMatrix = zeroCoordinate
                break
            }
            model.placeInMatrix = chipMove.chipModels[modelIndex+1].placeInMatrix
        }
        
        field.moveValuesToZero(from: movingCoordinates)
        
        checkGameIsDone()
        
    }
    
    private func checkGameIsDone() {
        
        self.isDone = field.chips.elementsEqual([[1,2,3,4],
                                                 [5,6,7,8],
                                                 [9,10,11,12],
                                                 [13,14,15,0]])
        
    }
}
