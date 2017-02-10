//
//  DancingLinks.swift
//  DancingLinks
//
//  Created by Takanari Hayama on 10/6/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import Foundation

class DancingLinksNode : Hashable {
    var D : DancingLinksNode!
    var U : DancingLinksNode!
    var R : DancingLinksNode!
    var L : DancingLinksNode!
    var C : DancingLinksColumn!
    
    static var hashSeed = 0
    
    var hashValue : Int
    
    init() {
        DancingLinksNode.hashSeed += 1
        self.hashValue = DancingLinksNode.hashSeed
        self.R = self
        self.L = self
        self.D = self
        self.U = self
    }

    func linkVirticalNode(_ node: DancingLinksNode) {
        if let column = self as? DancingLinksColumn {
            node.C = column
        }
        node.U = self.U
        node.D = self
        self.U.D = node
        self.U = node
        node.C?.size += 1
    }
    
    func linkHorizontalNode(_ node: DancingLinksNode) {
        // link to the row
        node.L = self.L
        node.R = self
        self.L.R = node
        self.L = node
    }
}

func ==(lhs: DancingLinksNode, rhs: DancingLinksNode) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class DancingLinksColumn : DancingLinksNode {
    let name : String
    var size : Int = 0

    var columns = [String: DancingLinksColumn]()

    init(name: String) {
        self.name = name
        super.init()
        self.C = self
    }
    
    func addColumnWithName(_ name: String) -> DancingLinksColumn {
        let column = DancingLinksColumn(name: name)
        linkHorizontalNode(column)
        return column
    }
    
    func findColumnWithName(_ name: String) -> DancingLinksColumn {
        if let column = columns[name] {
            return column
        }
        let column = addColumnWithName(name)
        columns[name] = column
        return column
    }

    func cover() {
        self.R.L = self.L
        self.L.R = self.R
        
        var row = self.D
        while row !== self {
            var node = row?.R
            while node !== row {
                node?.D.U = node?.U
                node?.U.D = node?.D
                node?.C.size -= 1

                node = node?.R
            }
            row = row?.D
        }
    }
    
    func uncover() {
        var row = self.U
        while row !== self {
            var node = row?.L
            while node !== row {
                node?.C.size += 1
                node?.D.U = node
                node?.U.D = node

                node = node?.L
            }
            row = row?.U
        }
        
        self.R.L = self
        self.L.R = self
    }
}

class DancingLinks {
    var header : DancingLinksColumn = DancingLinksColumn(name: "header")
    var rows = [Int:DancingLinksNode]()
    
    init(matrix: [String:[Int]]) {
        for (columnName, rows) in matrix {
            let columnNode = header.findColumnWithName(columnName)
            for rowNumber in rows {
                addNodeToColumn(columnNode, atRow: rowNumber)
            }
        }
    }
    
    init(matrix: [Int:[String]]) {
        for (rowNumber, columns) in matrix {
            for columnName in columns {
                let columnNode = header.findColumnWithName(columnName)
                addNodeToColumn(columnNode, atRow: rowNumber)
            }
        }
    }
    
    fileprivate func addNodeToColumn(_ columnNode: DancingLinksColumn, atRow rowNumber: Int) {
        let node = DancingLinksNode()
        
        columnNode.linkVirticalNode(node)
        
        if let headNode = self.rows[rowNumber] {
            headNode.linkHorizontalNode(node)
        } else {
            self.rows[rowNumber] = node
        }
    }
    
    var O = [DancingLinksNode]()
    
    func search(_ k: Int) {
        search(k, callback: printResult)
    }
    
    func search(_ k: Int, callback: ([DancingLinksNode]) -> Void) {
        if header.R === header {
            callback(O)
            return
        }
        
        guard let c = choose() else {
            return
        }
        
        c.cover()
        
        var r = c.D
        while r !== c {
            if O.count > k {
                O.remove(at: k)
            }
            O.insert(r!, at: k)

            var j = r?.R
            while j !== r {
                j?.C.cover()
                j = j?.R
            }
            search(k + 1, callback: callback)
            j = r?.L
            while j !== r {
                j?.C.uncover()
                j = j?.L
            }
            r = r?.D
        }
        c.uncover()
    }
    
    func choose() -> DancingLinksColumn? {
        var s : Int = Int.max
        var column = header.R as! DancingLinksColumn
        var selectedColumn : DancingLinksColumn?

        while column !== header {
            if column.size < s {
                s = column.size
                selectedColumn = column
            }
            column = column.R as! DancingLinksColumn
        }
        return selectedColumn
    }
    
    func printResult(_ O : [DancingLinksNode]) {
        for node in O {
            var r = node
            repeat {
                print("\(r.C.name) ", terminator: "")
                r = r.R
            } while r !== node
            print("⏎")
        }
        print("---")
    }
    
    func printMatrix() {
        var column = header.R as! DancingLinksColumn
        var columns = [String]()
        while column !== header {
            columns.append(column.name)
            column = column.R as! DancingLinksColumn
        }
        print("\(columns.sorted())⏎")
        
        let sortedRows = self.rows.sorted{ $0.0 < $1.0 }
        for (rowNumber, nodeHead) in sortedRows {
            var rows = [String]()
            rows.append(nodeHead.C.name)
            var node = nodeHead.R
            while node !== nodeHead {
                rows.append((node?.C.name)!)
                node = node?.R
            }
            print("\(rowNumber): \(rows.sorted())⏎")
        }
    }
}
