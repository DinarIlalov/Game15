//
//  ChipModel.swift
//  Game15
//
//  Created by Dinar Ilalov on 11/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import Foundation

final class ChipModel {
    var placeInMatrix: MatrixCoordinate
    let number: Int
    
    init(number: Int, placeInMatrix: MatrixCoordinate) {
        self.number = number
        self.placeInMatrix = placeInMatrix
    }
}
