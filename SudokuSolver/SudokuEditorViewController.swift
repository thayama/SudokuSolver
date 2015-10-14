//
//  SudokuEditorViewController.swift
//  SudokuSolver
//
//  Created by Takanari Hayama on 10/13/15.
//  Copyright © 2015 IGEL Co.,Ltd. All rights reserved.
//

import UIKit

class SudokuEditorViewController: UIViewController {
    @IBOutlet var boardButtons: [UIButton]!
    private var selectedBoardButton : UIButton?
    private var boardButtonIndex: [UIButton] = [UIButton]()
    private var gameData : SudokuGame!
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    private var nullData = [Int]()

    // Constants
    private let GameData = "GameData"
    private let ClearDialogTitle = NSLocalizedString("ClearDialogTitle", comment: "Title of all clear dialog")
    private let ClearDialogMessage = NSLocalizedString("ClearDialogMessage", comment: "Message of all clear dialog")
    private let OkButton = NSLocalizedString("Accept", comment: "OK button")
    private let CancelButton = NSLocalizedString("Cancel", comment: "Cancel button")
    private let ClearAll = NSLocalizedString("ClearAll", comment: "Clear all action")

    override func viewDidLoad() {
        var check = [Bool](count: boardButtons.count, repeatedValue: false)
        boardButtonIndex = [UIButton](count: boardButtons.count, repeatedValue: boardButtons[0])
        
        for button in boardButtons {
            if check[button.tag]  {
                print("duplicated tag \(button.tag)!")
            } else {
                check[button.tag] = true
                boardButtonIndex[button.tag] = button
            }
        }
        
        print("total=\(boardButtons.count) buttons")

        nullData = [Int](count: boardButtons.count, repeatedValue: 0)
        setGameData(userDefaults.arrayForKey(GameData) as? [Int] ?? nullData)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
        
        userDefaults.setObject(gameData.data, forKey: GameData)
        userDefaults.synchronize()
    }
    
    @IBAction func clearButtonPressed(sender: UIBarButtonItem) {
        let clearDialog = UIAlertController(title: ClearDialogTitle, message: ClearDialogMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: OkButton, style: UIAlertActionStyle.Default) { (action) -> Void in
            self.clearData(self.nullData)
        }
        let cancelAction = UIAlertAction(title: CancelButton, style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("cancelled")
        }
        
        clearDialog.addAction(okAction)
        clearDialog.addAction(cancelAction)

        presentViewController(clearDialog, animated: true, completion: nil)
    }
    
    func setGameData(data: [Int]) {
        gameData = SudokuGame(data: data)
        for (index, symbol) in data.enumerate() {
            boardButtonIndex[index].setTitle(symbol == 0 ? nil : "\(symbol)", forState: UIControlState.Normal)
        }
    }
    
    func clearData(data: [Int]) {
        undoManager?.registerUndoWithTarget(self, selector: Selector("clearData:"), object: gameData.data)
        undoManager?.setActionName(ClearAll)
        setGameData(data)
    }
    
    @IBAction func boardButtonPressed(sender: UIButton) {
        let previousButton = selectedBoardButton
        if selectedBoardButton != sender {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                sender.backgroundColor = UIColor.yellowColor()
            })
            selectedBoardButton = sender
        } else {
            selectedBoardButton = nil
        }
        previousButton?.backgroundColor = UIColor.whiteColor()
    }

    @IBAction func numberButtonPressed(sender: UIButton) {
        guard let button = selectedBoardButton else { return }
        
        let number = sender.tag
        
        if gameData.setSymbol(sender.tag, atCell: button.tag) {
            button.setTitle(number != 0 ? "\(number)" : nil, forState: UIControlState.Normal)
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                sender.backgroundColor = UIColor.redColor()
                }, completion: { (ignore) -> Void in
                    sender.backgroundColor = UIColor.whiteColor()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let srvc = segue.destinationViewController as? SudokuResultViewController {
            srvc.gameData = gameData
        }
    }
}
