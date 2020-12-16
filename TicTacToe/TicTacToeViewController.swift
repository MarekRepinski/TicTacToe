//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by Marek Repinski on 2020-12-15.
//

import UIKit

class TicTacToeViewController: UIViewController {
    var noOfPlayers = 0
    let blankImg = UIImage(named: "blank")
    let xImg = UIImage(named: "x")
    let oImg = UIImage(named: "o")
    @IBOutlet weak var img11: UIImageView!
    @IBOutlet weak var img12: UIImageView!
    @IBOutlet weak var img13: UIImageView!
    @IBOutlet weak var img21: UIImageView!
    @IBOutlet weak var img22: UIImageView!
    @IBOutlet weak var img23: UIImageView!
    @IBOutlet weak var img31: UIImageView!
    @IBOutlet weak var img32: UIImageView!
    @IBOutlet weak var img33: UIImageView!
    @IBOutlet weak var reslabel: UILabel!
    var cordMap = [[UIImageView]]()
    var theGame = TicTackToeGame()
    var timer: Timer?
    var blinkCnt = 0
    var blinkStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cordMap = [[img11, img12, img13], [img21, img22, img23], [img31, img32, img33]]
        clearPlayField()
        let theGame = TicTackToeGame()
        theGame.startNewGame()
        reslabel.text = ""
    }
    
    @IBAction func tapp11(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img11.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 0)
        }
    }
    
    @IBAction func tapp12(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img12.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 1)
        }
    }
    
    @IBAction func tapp13(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img13.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 2)
        }
    }
    
    @IBAction func tapp21(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img21.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 0)
        }
    }
    
    @IBAction func tapp22(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img22.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 1)
        }
    }
    
    @IBAction func tapp23(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img23.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 2)
        }
    }
    
    @IBAction func tapp31(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img31.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 0)
        }
    }
    
    @IBAction func tapp32(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img32.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 1)
        }
    }
    
    @IBAction func tapp33(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img33.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 2)
        }
    }
    
    func imageCompare(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    func imageTapped(y: Int, x: Int){
        if !theGame.endGame {
            if theGame.nextMoveX(y: y, x: x) {
                cordMap[y][x].image = xImg
                if theGame.endGame {
                    gameEnded(winner: "X")
                }
            } else {
                cordMap[y][x].image = oImg
                if theGame.endGame {
                    gameEnded(winner: "O")
                }
            }
        }
    }
    
    func gameEnded(winner: String){
        let winningLine = theGame.winningLine
        if winningLine[0].x == -1 {
            reslabel.text = "Game ended with a Draw"
        } else {
            reslabel.text = "\(winner)- Won!!"
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: blink(t:))
        }
    }
    
    func blink(t: Timer? = nil){
        blinkCnt += 1
        for wl in theGame.winningLine {
            if blinkStatus {
                cordMap[wl.y][wl.x].isHidden = true
            } else {
                cordMap[wl.y][wl.x].isHidden = false
            }
        }
        if blinkStatus {
            blinkStatus = false
        } else {
            if blinkCnt >= 10 {
                timer?.invalidate()
                blinkCnt = 0
            } else {
                blinkStatus = true
            }
        }
    }
    
    func clearPlayField(){
        for y in 0...2 {
            for x in 0...2 {
                cordMap[y][x].image = blankImg
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
