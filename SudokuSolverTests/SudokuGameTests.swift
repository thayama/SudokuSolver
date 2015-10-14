//
//  SudokuGameTests.swift
//  SudokuSolver
//
//  Created by Takanari Hayama on 10/21/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import XCTest
@testable import SudokuSolver

class SudokuGameTests: XCTestCase {
    
    // ok case (1) - null data
    func testInitNullData() {
        if let gameData = SudokuGame(data: [Int](count: 81, repeatedValue: 0)) {
            for symbol in gameData.data {
                XCTAssert(symbol == 0)
            }
        } else {
            XCTFail("SudokuGame() init failed")
        }
    }
    
    // ok case (2) - really good data
    func testInitGoodData() {
        let goodData = [
            0, 0, 0, 0, 0, 0, 8, 2, 0,
            0, 2, 0, 3, 7, 0, 0, 5, 0,
            1, 0, 0, 8, 0, 4, 0, 7, 3,
            0, 7, 6, 9, 0, 0, 2, 0, 4,
            0, 0, 0, 7, 0, 2, 0, 0, 0,
            2, 0, 8, 0, 0, 1, 7, 3, 0,
            4, 1, 0, 6, 0, 5, 0, 0, 7,
            0, 5, 0, 0, 3, 8, 0, 9, 0,
            0, 8, 3, 0, 0, 0, 0, 0, 0
        ]
        if let gameData = SudokuGame(data: goodData) {
            for (index, symbol) in gameData.data.enumerate() {
                XCTAssert(goodData[index] == symbol)
            }
        } else {
            XCTFail("SudokuGame() init failed")
        }
    }
    
    // bad case (1) - illeagal symbol
    func testInitBadSymbol() {
        var data = [Int](count: 81, repeatedValue: 0)
        data[20] = 13
        XCTAssert(SudokuGame(data: data) == nil)
    }
    
    // bad case (2) - bad size
    func testInitBadSize() {
        // too small
        XCTAssert(SudokuGame(data: [Int](count: 80, repeatedValue: 0)) == nil)
        
        // too big
        XCTAssert(SudokuGame(data: [Int](count: 82, repeatedValue: 0)) == nil)
    }
    
    // bad case (4) - duplicated symbols
    func testInitDuplicateSymbols() {
        // row
        var data = [Int](count: 81, repeatedValue: 0)
        data[0] = 1
        data[1] = 1
        XCTAssert(SudokuGame(data: data) == nil)
    
        // column
        data = [Int](count: 81, repeatedValue: 0)
        data[0] = 1
        data[9] = 1
        XCTAssert(SudokuGame(data: data) == nil)

        // box
        data = [Int](count: 81, repeatedValue: 0)
        data[0] = 1
        data[20] = 1
        XCTAssert(SudokuGame(data: data) == nil)
    }
}
