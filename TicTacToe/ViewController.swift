//
//  ViewController.swift
//  TicTacToe
//
//  Created by Marek Repinski on 2020-12-15.
//

import UIKit

class ViewController: UIViewController {
    let segueToGameTwoP = "segueToGameTwoP"
    let segueToGameOneP = "segueToGameTwoP"
    var noOfPlayers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onePlayer(_ sender: UIButton) {
        performSegue(withIdentifier: segueToGameOneP, sender: self)
    }
    
    @IBAction func twoPlayer(_ sender: UIButton) {
        performSegue(withIdentifier: segueToGameTwoP, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToGameTwoP {
            let destinationVC = segue.destination as! TicTacToeViewController
            destinationVC.noOfPlayers = noOfPlayers
        }
    }
    
    @IBAction func unwindToStartView(segue: UIStoryboardSegue){}
}

