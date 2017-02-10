//
//  SudokuSolver.swift
//  DancingLinks
//
//  Created by Takanari Hayama on 10/9/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import Foundation

class SudokuSolver {
    fileprivate let size : Int
    fileprivate let n : Int
    var sudokuResult : [Int]?
    
    init(n: Int) {
        self.n = n
        size = n * n
    }
    
    func createRowForSymbol(_ symbol: Int, atCell cell: Int) -> [String] {
        return [
            "C\(cell)",
            "S\(symbol)R\(cell / size)",
            "S\(symbol)C\(cell % size)",
            "S\(symbol)B\((cell / n / n / n) * n + (cell % size) / n)"
        ]
    }
    
    func setSudokuData(_ data: [Int]) -> Bool {
        guard data.count == size * size else { return false }
        
        var sudokuMatrix = [Int:[String]]()
        var row = 0
        var c = 0
        
        for s in data {
            switch s {
            case 0:
                for symbol in 1...size {
                    sudokuMatrix[row] = createRowForSymbol(symbol, atCell: c)
                    row += 1
                }
                
            case 1...size:
                sudokuMatrix[row] = createRowForSymbol(s, atCell: c)
                row += 1
                
            default:
                return false
            }
            c += 1
        }
        
        let dlx = DancingLinks(matrix: sudokuMatrix)
        sudokuResult = nil
        dlx.search(0, callback: getResult)
        
        return true
    }
    
    func getResult(_ result: [DancingLinksNode]) {
        sudokuResult = [Int](repeating: 0, count: size * size)

        for o in result {
            var node = o
            var cell = -1
            var symbol = 0
            repeat {
                let cname = node.C.name
                
                switch (cname[cname.startIndex]) {
                case "C":
                    cell = Int(cname.substring(from: cname.characters.index(after: cname.startIndex)))!
                case "S":
                    symbol = Int(String(cname[cname.characters.index(after: cname.startIndex)]))!
                default:
                    break
                }
                node = node.R
            } while (cell == -1 || symbol == 0) && o !== node
            sudokuResult?[cell] = symbol
        }
    }
    
    func showResult() {
        if let result = sudokuResult {
            for y in 0..<9 {
                for x in 0..<9 {
                    print("\(result[y * 9 + x]) ", terminator: (x != 8 && x % 3 == 2) ? "|" : "")
                }
                print((y != 8 && y % 3 == 2) ? "\n------+------+------" : "")
            }
        } else {
            print("No result")
        }
    }
}
