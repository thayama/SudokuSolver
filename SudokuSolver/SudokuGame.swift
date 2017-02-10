//
//  SudokuGame.swift
//  SudokuSolver
//
//  Created by Takanari Hayama on 10/13/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import Foundation

class SudokuGame {
    fileprivate var gameData : [Int]
    fileprivate let n : Int
    let size : Int
    let maxCells : Int
    
    var data : [Int] {
        return gameData
    }
    
    fileprivate var rows : [Int]
    fileprivate var columns : [Int]
    fileprivate var boxes : [Int]
    
    init?(data: [Int]) {
        n = Int(sqrt(sqrt(Double(data.count))))
        size = n * n
        maxCells = data.count
        self.gameData = [Int](repeating: 0, count: data.count)
        
        rows = [Int](repeating: 0, count: size)
        columns = [Int](repeating: 0, count: size)
        boxes = [Int](repeating: 0, count: size)
        
        if size > 32 || size * size != data.count || !setSymbolData(data) {
            return nil
        }
    }
    
    fileprivate func setSymbolData(_ data: [Int]) -> Bool {
        for (index, symbol) in data.enumerated() {
            if !setSymbol(symbol, atCell: index) {
                return false
            }
        }
        return true
    }

    func setSymbol(_ symbol: Int, atCell cell: Int) -> Bool {
        guard symbol >= 0 && symbol <= size &&
            cell >= 0 && cell < maxCells else { return false }

        let x = cell % size
        let y = cell / size
        let b = (cell / size / n) * n + (cell % size) / n

        var status = true

        // clear the old symbol
        if gameData[cell] != 0 {
            let flag = ~(1 << (gameData[cell] - 1))
            rows[y] &= flag
            columns[x] &= flag
            boxes[b] &= flag
        }
        
        // set the new symbol
        if symbol != 0 {
            let flag = 1 << (symbol - 1)
            status = ((rows[y] | columns[x] | boxes[b]) & flag) == 0
            rows[y] |= flag
            columns[x] |= flag
            boxes[b] |= flag
        }

        if status {
            gameData[cell] = symbol
        }
        
        return status
    }
}
