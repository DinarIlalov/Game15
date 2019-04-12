//
//  ChipsMatrix.swift
//  Game15
//
//  Created by Dinar Ilalov on 10/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import Foundation

struct MatrixCoordinate: Equatable {
    let rowIndex: Int
    let columnIndex: Int
    
    static func == (lhs: MatrixCoordinate, rhs: MatrixCoordinate) -> Bool {
        return lhs.columnIndex == rhs.columnIndex && lhs.rowIndex == rhs.rowIndex
    }
}

class ChipsMatrix {
    
    // MARK: Properties
    
    private let rowsCount: Int
    private let columnsCount: Int
    
    var chips: [[Int]] = []
    
    var zeroElement = MatrixCoordinate(rowIndex: 0, columnIndex: 0)
    
    // MARK: - Init
    
    init(rowsCount: Int, columnsCount: Int) {
        self.rowsCount = rowsCount
        self.columnsCount = columnsCount
        reset()
    }
    
    subscript(rowIndex: Int, columnIndex: Int) -> Int {
        get {
            return chips[rowIndex][columnIndex]
        }
        set {
            chips[rowIndex][columnIndex] = newValue
        }
    }
    
    // MARK: - Public
    
    func reset() {
        
        self.chips.removeAll()
        
        // 1...15, last = zero
        var shuffledArray = Array((1...(rowsCount*columnsCount-1))).shuffled()
        for _ in 0..<rowsCount {
            var row: [Int] = []
            for _ in 0..<columnsCount {
                row.append(shuffledArray.popLast() ?? 0)
            }
            self.chips.append(row)
        }
        
        change14And15ifNeeded()
        
        zeroElement = MatrixCoordinate(rowIndex: 3, columnIndex: 3)
    }
    
    func moveToZeroValue(from coordinate: MatrixCoordinate) -> MatrixCoordinate {
        guard canMoveToZero(from: coordinate) != .none else { return coordinate}
        
        let newChipCoordinate = zeroElement
        self[zeroElement.rowIndex, zeroElement.columnIndex] = self[coordinate.rowIndex, coordinate.columnIndex]
        self[coordinate.rowIndex, coordinate.columnIndex] = 0
        self.zeroElement = coordinate
        
        return newChipCoordinate
    }
    
    func canMoveToZero(from coordinate: MatrixCoordinate) -> AvailableMoveDirection {
        
        let upNeighbour = MatrixCoordinate(rowIndex: coordinate.rowIndex-1, columnIndex: coordinate.columnIndex)
        let downNeighbour = MatrixCoordinate(rowIndex: coordinate.rowIndex+1, columnIndex: coordinate.columnIndex)
        let rightNeighbour = MatrixCoordinate(rowIndex: coordinate.rowIndex, columnIndex: coordinate.columnIndex+1)
        let leftNeighbour = MatrixCoordinate(rowIndex: coordinate.rowIndex, columnIndex: coordinate.columnIndex-1)
        
        if zeroElement == upNeighbour { return .up }
        if zeroElement == downNeighbour { return .down }
        if zeroElement == leftNeighbour { return .left }
        if zeroElement == rightNeighbour { return .right }
        
        return .none
    }
    
    // MARK: - Private
    
    private func change14And15ifNeeded() {
        var sum = 4 // zero in last row
        
        let flatten = Array(self.chips.joined())
        
        for (index, value) in flatten.enumerated() {
            
            for index2 in ((index + 1)..<16) {
                
                if value > flatten[index2] && flatten[index2] != 0 {
                    sum += 1
                }
                
            }
        }
        
        if sum % 2 != 0 {
            let temp = chips[0][0]
            chips[0][0] = chips[0][1]
            chips[0][1] = temp
            
            print("changed")
        }
        
    }
}

