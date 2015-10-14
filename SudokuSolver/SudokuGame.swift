//
//  SudokuGame.swift
//  SudokuSolver
//
//  Created by Takanari Hayama on 10/13/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import Foundation

class SudokuGame {
    private var gameData : [Int]
    private let n : Int
    let size : Int
    let maxCells : Int
    
    var data : [Int] {
        return gameData
    }
    
    private var rows : [Int]
    private var columns : [Int]
    private var boxes : [Int]
    
    init?(data: [Int]) {
        n = Int(sqrt(sqrt(Double(data.count))))
        size = n * n
        maxCells = data.count
        self.gameData = [Int](count: data.count, repeatedValue: 0)
        
        rows = [Int](count: size, repeatedValue: 0)
        columns = [Int](count: size, repeatedValue: 0)
        boxes = [Int](count: size, repeatedValue: 0)
        
        if size > 32 || size * size != data.count || !setSymbolData(data) {
            return nil
        }
    }
    
    private func setSymbolData(data: [Int]) -> Bool {
        for (index, symbol) in data.enumerate() {
            if !setSymbol(symbol, atCell: index) {
                return false
            }
        }
        return true
    }

    func setSymbol(symbol: Int, atCell cell: Int) -> Bool {
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