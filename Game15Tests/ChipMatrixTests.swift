//
//  ChipMatrixTests.swift
//  Game15Tests
//
//  Created by Dinar Ilalov on 17/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import XCTest

@testable import Game15
class ChipMatrixTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovementSuccess() {
        let chipMatrix = ChipsMatrix(rowsCount: 4, columnsCount: 4)
        
        /*
         [*, *, *, *]
         [*, *, *, *]
         [*, *, *, *]
         [*, *, *, 0]
        */
        
        let movementValues1 = chipMatrix.moveValuesToZero(from: MatrixCoordinate(rowIndex: 3, columnIndex: 0))
        let movementValuesModel1 = [
            MatrixCoordinate(rowIndex: 3, columnIndex: 1),
            MatrixCoordinate(rowIndex: 3, columnIndex: 2),
            MatrixCoordinate(rowIndex: 3, columnIndex: 3)
        ]
        
        /*
         [*, *, *, *]
         [*, *, *, *]
         [*, *, *, *]
         [0, *, *, *]
         */
        
        XCTAssertEqual(movementValuesModel1, movementValues1)
        
        let movementValues2 = chipMatrix.moveValuesToZero(from: MatrixCoordinate(rowIndex: 2, columnIndex: 0))
        let movementValuesModel2 = [
            MatrixCoordinate(rowIndex: 3, columnIndex: 0)
        ]
        
        /*
         [*, *, *, *]
         [*, *, *, *]
         [0, *, *, *]
         [*, *, *, *]
         */
        
        XCTAssertEqual(movementValuesModel2, movementValues2)
        
        let movementValues3 = chipMatrix.moveValuesToZero(from: MatrixCoordinate(rowIndex: 2, columnIndex: 2))
        let movementValuesModel3 = [
            MatrixCoordinate(rowIndex: 2, columnIndex: 1),
            MatrixCoordinate(rowIndex: 2, columnIndex: 0)
        ]
        
        /*
         [*, *, *, *]
         [*, *, *, *]
         [*, *, 0, *]
         [*, *, *, *]
         */
        
        XCTAssertEqual(movementValuesModel3, movementValues3)
        
        let movementValues4 = chipMatrix.moveValuesToZero(from: MatrixCoordinate(rowIndex: 0, columnIndex: 0))
        let movementValuesModel4 = [
            MatrixCoordinate(rowIndex: 0, columnIndex: 0)
        ]
        
        /*
         [!, *, *, *]
         [*, *, *, *]
         [*, *, 0, *]
         [*, *, *, *]
         */
        
        XCTAssertEqual(movementValuesModel4, movementValues4)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
