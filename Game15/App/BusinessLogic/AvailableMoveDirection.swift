//
//  AvailableMoveDirection.swift
//  Game15
//
//  Created by Dinar Ilalov on 11/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import Foundation

enum AvailableMoveDirection: Equatable {
    case up(Int)
    case down(Int)
    case left(Int)
    case right(Int)
    case none
}
