//
//  ViewController.swift
//  TicTacToe
//  Controller to first page.
//
//  Created by Marek Repinski on 2020-12-15.
//

import UIKit

class ViewController: UIViewController {
    let segueToGame = "segueToGameTwoP"
    var noOfPlayers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onePlayer(_ sender: UIButton) {
        noOfPlayers = 1
        performSegue(withIdentifier: segueToGame, sender: self)
    }
    
    @IBAction func twoPlayer(_ sender: UIButton) {
        noOfPlayers = 2
        performSegue(withIdentifier: segueToGame, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToGame {
            let destinationVC = segue.destination as! TicTacToeViewController
            destinationVC.noOfPlayers = noOfPlayers
        }
    }
    
    @IBAction func unwindToStartView(segue: UIStoryboardSegue){}
}

