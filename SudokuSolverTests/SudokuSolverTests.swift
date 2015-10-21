//
//  SudokuSolverTests.swift
//  DancingLinks
//
//  Created by Takanari Hayama on 10/9/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import XCTest
@testable import SudokuSolver

class SudokuSolverTests: XCTestCase {

    func testSolver() {
        let solver = SudokuSolver(n: 3)
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
        XCTAssert(solver.setSudokuData(goodData))
        XCTAssert(solver.sudokuResult != nil)
        solver.showResult()

        let expectedResult = [
            7, 3, 4, 1, 5, 9, 8, 2, 6,
            8, 2, 9, 3, 7, 6, 4, 5, 1,
            1, 6, 5, 8, 2, 4, 9, 7, 3,
            5, 7, 6, 9, 8, 3, 2, 1, 4,
            3, 9, 1, 7, 4, 2, 5, 6, 8,
            2, 4, 8, 5, 6, 1, 7, 3, 9,
            4, 1, 2, 6, 9, 5, 3, 8, 7,
            6, 5, 7, 4, 3, 8, 1, 9, 2,
            9, 8, 3, 2, 1, 7, 6, 4, 5
        ]
        
        if let result = solver.sudokuResult {
            XCTAssert(result == expectedResult)
        } else {
            XCTFail("No solution found")
        }
        
        let goodData2 = [
            0, 0, 0, 0, 0, 0, 8, 2, 0,
            0, 2, 0, 3, 7, 0, 0, 0, 0,
            1, 0, 0, 8, 0, 4, 0, 0, 3,
            0, 7, 6, 9, 0, 0, 2, 0, 4,
            0, 0, 0, 7, 0, 2, 0, 0, 0,
            2, 0, 8, 0, 0, 1, 7, 3, 0,
            4, 1, 0, 6, 0, 5, 0, 0, 7,
            0, 5, 0, 0, 3, 8, 0, 9, 0,
            0, 8, 3, 0, 0, 0, 0, 0, 0
        ]
        XCTAssert(solver.setSudokuData(goodData2))
        solver.showResult()
    }
    
    func testBadData() {
        let solver = SudokuSolver(n: 3)
        let noSolutionData = [
            3, 0, 0, 0, 0, 0, 8, 2, 0,
            0, 2, 0, 3, 7, 0, 0, 5, 0,
            1, 0, 0, 8, 0, 4, 0, 7, 3,
            0, 7, 6, 9, 0, 0, 2, 0, 4,
            0, 0, 0, 7, 0, 2, 0, 0, 0,
            2, 0, 8, 0, 0, 1, 7, 3, 0,
            4, 1, 0, 6, 0, 5, 0, 0, 7,
            0, 5, 0, 0, 3, 8, 0, 9, 0,
            0, 8, 3, 0, 0, 0, 0, 0, 0
        ]
        XCTAssert(solver.setSudokuData(noSolutionData))
        XCTAssert(solver.sudokuResult == nil)
        
        let badData = [
            10, 0, 0, 0, 0, 0, 8, 2, 0,
            0, 2, 0, 3, 7, 0, 0, 5, 0,
            1, 0, 0, 8, 0, 4, 0, 7, 3,
            0, 7, 6, 9, 0, 0, 2, 0, 4,
            0, 0, 0, 7, 0, 2, 0, 0, 0,
            2, 0, 8, 0, 0, 1, 7, 3, 0,
            4, 1, 0, 6, 0, 5, 0, 0, 7,
            0, 5, 0, 0, 3, 8, 0, 9, 0,
            0, 8, 3, 0, 0, 0, 0, 0, 0
        ]
        XCTAssert(!solver.setSudokuData(badData))
        XCTAssert(solver.sudokuResult == nil)

        let shortData = [
            1, 0, 0, 0, 0, 0, 8, 2, 0,
            0, 2, 0, 3, 7, 0, 0, 5, 0,
            1, 0, 0, 8, 0, 4, 0, 7, 3,
            0, 7, 6, 9, 0, 0, 2, 0, 4,
            0, 0, 0, 7, 0, 2, 0, 0, 0,
            2, 0, 8, 0, 0, 1, 7, 3, 0,
            4, 1, 0, 6, 0, 5, 0, 0, 7,
            0, 5, 0, 0, 3, 8, 0, 9, 0,
            0, 8, 3, 0, 0, 0, 0, 0
        ]
        XCTAssert(!solver.setSudokuData(shortData))
        XCTAssert(solver.sudokuResult == nil)

        let longData = [
            1, 0, 0, 0, 0, 0, 8, 2, 0,
            0, 2, 0, 3, 7, 0, 0, 5, 0,
            1, 0, 0, 8, 0, 4, 0, 7, 3,
            0, 7, 6, 9, 0, 0, 2, 0, 4,
            0, 0, 0, 7, 0, 2, 0, 0, 0,
            2, 0, 8, 0, 0, 1, 7, 3, 0,
            4, 1, 0, 6, 0, 5, 0, 0, 7,
            0, 5, 0, 0, 3, 8, 0, 9, 0,
            0, 8, 3, 0, 0, 0, 0, 0, 0, 0
        ]
        XCTAssert(!solver.setSudokuData(longData))
        XCTAssert(solver.sudokuResult == nil)
    }

}
