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
    fileprivate var selectedBoardButton : UIButton?
    fileprivate var boardButtonIndex: [UIButton] = [UIButton]()
    fileprivate var gameData : SudokuGame!
    fileprivate let userDefaults = UserDefaults.standard
    fileprivate var nullData = [Int]()

    // Constants
    fileprivate let GameData = "GameData"
    fileprivate let ClearDialogTitle = NSLocalizedString("ClearDialogTitle", comment: "Title of all clear dialog")
    fileprivate let ClearDialogMessage = NSLocalizedString("ClearDialogMessage", comment: "Message of all clear dialog")
    fileprivate let OkButton = NSLocalizedString("Accept", comment: "OK button")
    fileprivate let CancelButton = NSLocalizedString("Cancel", comment: "Cancel button")
    fileprivate let ClearAll = NSLocalizedString("ClearAll", comment: "Clear all action")

    override func viewDidLoad() {
        var check = [Bool](repeating: false, count: boardButtons.count)
        boardButtonIndex = [UIButton](repeating: boardButtons[0], count: boardButtons.count)
        
        for button in boardButtons {
            if check[button.tag]  {
                print("duplicated tag \(button.tag)!")
            } else {
                check[button.tag] = true
                boardButtonIndex[button.tag] = button
            }
        }
        
        print("total=\(boardButtons.count) buttons")

        nullData = [Int](repeating: 0, count: boardButtons.count)
        setGameData(userDefaults.array(forKey: GameData) as? [Int] ?? nullData)
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
        
        userDefaults.set(gameData.data, forKey: GameData)
        userDefaults.synchronize()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        let clearDialog = UIAlertController(title: ClearDialogTitle, message: ClearDialogMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: OkButton, style: UIAlertActionStyle.default) { (action) -> Void in
            self.clearData(self.nullData)
        }
        let cancelAction = UIAlertAction(title: CancelButton, style: UIAlertActionStyle.cancel) { (action) -> Void in
            print("cancelled")
        }
        
        clearDialog.addAction(okAction)
        clearDialog.addAction(cancelAction)

        present(clearDialog, animated: true, completion: nil)
    }
    
    func setGameData(_ data: [Int]) {
        gameData = SudokuGame(data: data)
        for (index, symbol) in data.enumerated() {
            boardButtonIndex[index].setTitle(symbol == 0 ? nil : "\(symbol)", for: UIControlState())
        }
    }
    
    func clearData(_ data: [Int]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(SudokuEditorViewController.clearData(_:)), object: gameData.data)
        undoManager?.setActionName(ClearAll)
        setGameData(data)
    }
    
    @IBAction func boardButtonPressed(_ sender: UIButton) {
        let previousButton = selectedBoardButton
        if selectedBoardButton != sender {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                sender.backgroundColor = UIColor.yellow
            })
            selectedBoardButton = sender
        } else {
            selectedBoardButton = nil
        }
        previousButton?.backgroundColor = UIColor.white
    }

    @IBAction func numberButtonPressed(_ sender: UIButton) {
        guard let button = selectedBoardButton else { return }
        
        let number = sender.tag
        
        if gameData.setSymbol(sender.tag, atCell: button.tag) {
            button.setTitle(number != 0 ? "\(number)" : nil, for: UIControlState())
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                sender.backgroundColor = UIColor.red
                }, completion: { (ignore) -> Void in
                    sender.backgroundColor = UIColor.white
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let srvc = segue.destination as? SudokuResultViewController {
            srvc.gameData = gameData
        }
    }
}
