//
//  SudokuResultViewController.swift
//  SudokuSolver
//
//  Created by Takanari Hayama on 10/16/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import UIKit

class SudokuResultViewController: UIViewController {
    @IBOutlet var cellLabels: [UILabel]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var timeLabel: UILabel!
    var cells = [UILabel]()
    var knownCells = [Bool]()
    var solver: SudokuSolver?
    var duration: TimeInterval = 0
    
    var gameData : SudokuGame? {
        didSet {
            if let data = gameData {
                knownCells = [Bool](repeating: false, count: data.maxCells)
                for (index, cell) in data.data.enumerated() {
                    knownCells[index] = (cell != 0)
                }
            } else {
                knownCells = [Bool]()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard cellLabels.count == gameData?.maxCells else {
            print("# of cells in gameData and view don't match!")
            return
        }
        
        cells = [UILabel](repeating: cellLabels[0], count: cellLabels.count)
        for cell in cellLabels {
            cells[cell.tag] = cell
        }
        
        activityIndicator.startAnimating()
        timeLabel.isHidden = true
        DispatchQueue.global(qos: DispatchQoS.default.qosClass).async { self.solve() }
        
        title = NSLocalizedString("ComputingMessage", comment: "Computing a solution")
    }
    
    func solve() {
        guard let data = gameData else { return }
        
        let start = Date()
        
        solver = SudokuSolver(n: 3)
        
        if solver!.setSudokuData(data.data) {
            duration = Date().timeIntervalSince(start)
            
            print("time=\(duration)")
            
            solver!.showResult()
            
            DispatchQueue.main.async { self.updateUI() }
        } else {
            print("Failed to set puzzle data.")
        }
    }
    
    func updateUI() {
        activityIndicator.stopAnimating()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        if let time = formatter.string(from: NSNumber(integerLiteral: Int(round(duration * 1000)))) {
            timeLabel.text = time + " msec"
            timeLabel.isHidden = false
        }
        
        if let result = solver?.sudokuResult {
            for (index, cell) in knownCells.enumerated() {
                cells[index].text = "\(result[index])"
                cells[index].textColor = cell ? UIColor.lightGray : UIColor.black
            }
            title = NSLocalizedString("SolvedMessage", comment: "Found the solution")
        } else {
            for (index, cell) in knownCells.enumerated() where cell == true {
                if let symbol = gameData?.data[index] {
                    cells[index].text = String(symbol)
                }
                cells[index].textColor = UIColor.lightGray
            }
            title = NSLocalizedString("NoSolutionMessage", comment: "No solution found")
            showNoSolutionDialog()
        }
    }
    
    func showNoSolutionDialog() {
        let noSolutionDialogTitle = NSLocalizedString("NoSolutionDialogTitle", comment: "Title of no solution dialog")
        let noSolutionDialogMessage = NSLocalizedString("NoSolutionDialogMessage", comment: "Message of no solution dialog")
        let okButton = NSLocalizedString("Accept", comment: "OK button")
        
        let noSolutionDialog = UIAlertController(title: noSolutionDialogTitle, message: noSolutionDialogMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: okButton, style: UIAlertActionStyle.default, handler: nil)
        noSolutionDialog.addAction(okAction)
        present(noSolutionDialog, animated: true, completion: nil)
    }
}
