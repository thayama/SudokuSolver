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
    var solver : SudokuSolver?
    var duration : NSTimeInterval = 0
    
    var gameData : SudokuGame? {
        didSet {
            if let data = gameData {
                knownCells = [Bool](count: data.maxCells, repeatedValue: false)
                for (index, cell) in data.data.enumerate() {
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
        
        cells = [UILabel](count: cellLabels.count, repeatedValue: cellLabels[0])
        for cell in cellLabels {
            cells[cell.tag] = cell
        }
        
        activityIndicator.startAnimating()
        timeLabel.hidden = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { self.solve() }
        
        title = NSLocalizedString("ComputingMessage", comment: "Computing a solution")
    }
    
    func solve() {
        guard let data = gameData else { return }
        
        let start = NSDate()
        
        solver = SudokuSolver(n: 3)
        solver?.setSudokuData(data.data)
        
        duration = NSDate().timeIntervalSinceDate(start)
        
        print("time=\(duration)")
        
        solver?.showResult()
        
        dispatch_async(dispatch_get_main_queue()) { self.updateUI() }
    }
    
    func updateUI() {
        activityIndicator.stopAnimating()
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if let time = formatter.stringFromNumber(Int(round(duration * 1000))) {
            timeLabel.text = time + " msec"
            timeLabel.hidden = false
        }
        
        if let result = solver?.sudokuResult {
            for (index, cell) in knownCells.enumerate() {
                cells[index].text = "\(result[index])"
                cells[index].textColor = cell ? UIColor.lightGrayColor() : UIColor.blackColor()
            }
            title = NSLocalizedString("SolvedMessage", comment: "Found the solution")
        } else {
            for (index, cell) in knownCells.enumerate() where cell == true {
                if let symbol = gameData?.data[index] {
                    cells[index].text = String(symbol)
                }
                cells[index].textColor = UIColor.lightGrayColor()
            }
            title = NSLocalizedString("NoSolutionMessage", comment: "No solution found")
            showNoSolutionDialog()
        }
    }
    
    func showNoSolutionDialog() {
        let noSolutionDialogTitle = NSLocalizedString("NoSolutionDialogTitle", comment: "Title of no solution dialog")
        let noSolutionDialogMessage = NSLocalizedString("NoSolutionDialogMessage", comment: "Message of no solution dialog")
        let okButton = NSLocalizedString("Accept", comment: "OK button")
        
        let noSolutionDialog = UIAlertController(title: noSolutionDialogTitle, message: noSolutionDialogMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: okButton, style: UIAlertActionStyle.Default, handler: nil)
        noSolutionDialog.addAction(okAction)
        presentViewController(noSolutionDialog, animated: true, completion: nil)
    }
}