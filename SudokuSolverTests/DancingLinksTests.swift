//
//  DancingLinksTests.swift
//  DancingLinksTests
//
//  Created by Takanari Hayama on 10/6/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import XCTest
@testable import SudokuSolver

class DancingLinksTests: XCTestCase {
    let testData = [
        "A" : [1, 3],
        "B" : [2, 4],
        "C" : [0, 2],
        "D" : [1, 3, 5],
        "E" : [0, 5],
        "F" : [0, 2],
        "G" : [1, 4, 5]
    ]
    
    let testData2 = [
        0 : ["C", "E", "F"],
        1 : ["A", "D", "G"],
        2 : ["B", "C", "F"],
        3 : ["A", "D"],
        4 : ["B", "G"],
        5 : ["D", "E", "G"]
    ]

    let expectedResult = [
        0 : ["A", "D"],
        1 : ["G", "B"],
        2 : ["C", "F", "E"]
    ]
    
    let expectedResult2 = [
        0 : ["B", "G"],
        1 : ["D", "A"],
        2 : ["E", "F", "C"]
    ]
    
    func checkResult(result: [DancingLinksNode]) {
        checkResult(result, expectedResult: expectedResult)
    }

    func checkResult2(result: [DancingLinksNode]) {
        checkResult(result, expectedResult: expectedResult2)
    }

    func checkResult(result: [DancingLinksNode], expectedResult: [Int:[String]]) {
        var n = 0
        for node in result {
            var r = node
            if let answer = expectedResult[n++] {
                var j = 0
                repeat {
                    XCTAssert(r.C.name == answer[j], "\(r.C.name) and \(answer[j]) dont' match")
                    j++
                    r = r.R
                } while r !== node
            } else {
                XCTAssert(false)
            }
        }
    }
    
    
    func testCreateMatrixByColumns() {
        let dlx : DancingLinks = DancingLinks(matrix: testData)
        dlx.printMatrix()
        
        dlx.search(0, callback: checkResult)
    }

    func testCreateMatrixByRows() {
        let dlx : DancingLinks = DancingLinks(matrix: testData2)
        dlx.printMatrix()
        
        dlx.search(0, callback: checkResult2)
    }

    func testPerformance() {
        // This is an example of a performance test case.
        let dlx : DancingLinks = DancingLinks(matrix: testData2)
        self.measureBlock {
            dlx.search(0)
        }
    }
    
}
