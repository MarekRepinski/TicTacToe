//
//  TicTacToeViewController.swift
//  TicTacToe
//  Main app controller
//
//  Created by Marek Repinski on 2020-12-15.
//

import UIKit

class TicTacToeViewController: UIViewController {
    var noOfPlayers = 0                             //1 or 2 player
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
    @IBOutlet weak var computerLabel: UILabel!
    @IBOutlet weak var xWins: UILabel!
    @IBOutlet weak var oWins: UILabel!
    @IBOutlet weak var xMoves: UILabel!
    @IBOutlet weak var oMoves: UILabel!
    @IBOutlet weak var xTime: UILabel!
    @IBOutlet weak var oTime: UILabel!
    @IBOutlet weak var yourTurnLabel: UILabel!
    @IBOutlet weak var playAgianButton: UIButton!
    var cordMap = [[UIImageView]]()                 // 2-D array of TicTacToe pictures
    var theGame = TicTackToeGame()                  // Main game
    var timer: Timer?                               // Timer for blinking winning row
    var xTimer: Timer?                              // Timer for X-player
    var oTimer: Timer?                              // Timer for O-player
    var stopTime = Date()                           // Stop X-player clock, start O-player clock
    var startTime = Date()                          // Stop O-player clock, start X-player clock
    var runXTime: TimeInterval = 0.0                // Count sec for X-player
    var runOTime: TimeInterval = 0.0                // Count sec for O-player
    var blinkCnt = 0                                // used by function "blink"
    var blinkStatus = false                         // used by function "blink"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cordMap = [[img11, img12, img13], [img21, img22, img23], [img31, img32, img33]]
        xWins.text = "0"
        oWins.text = "0"
        startGame()
        if noOfPlayers == 1 {
            computerLabel.isHidden = false
        } else {
            computerLabel.isHidden = true
        }
    }
    
    //Start first game
    private func startGame(){
        timer?.invalidate()
        clearPlayField()
        playAgianButton.isHidden = true
        yourTurnLabel.isHidden = false
        yourTurnLabel.text = "You start"
        xMoves.text = "0"
        oMoves.text = "0"
        xTime.text = "00:00"
        oTime.text = "00:00"
        runXTime = 0.0
        runOTime = 0.0
        startTime = Date()
        stopTime = Date()
        if theGame.xStart {
            reslabel.text = "X-Player"
            if let oTimer = oTimer {
                oTimer.invalidate()
            }
            xTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateXTimeLabel(t:))
        } else {
            reslabel.text = "O-Player"
            if let xTimer = xTimer {
                xTimer.invalidate()
            }
            oTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateOTimeLabel(t:))
        }
    }
    
    // Handle end of the game
    func gameEnded(winner: String){
        let winningLine = theGame.winningLine
        if winningLine[0].x == -1 {
            reslabel.text = "Game ended with a Draw"
        } else {
            reslabel.text = "\(winner) - player Won!!"
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: blink(t:))
        }
        yourTurnLabel.isHidden = true
        playAgianButton.isHidden = false
        let wins = theGame.playerWins
        xWins.text = String(wins.xPlayer)
        oWins.text = String(wins.oPlayer)
        xTimer?.invalidate()
        oTimer?.invalidate()
    }
    
    // Blink the winning line
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
    
    // Set blank images in matrix
    private func clearPlayField(){
        for y in 0...2 {
            for x in 0...2 {
                cordMap[y][x].image = blankImg
                cordMap[y][x].isHidden = false
            }
        }
    }

    // Update X-Player time
    private func updateXTimeLabel(t: Timer? = nil){
        var rTime = runXTime
        rTime += Date().timeIntervalSince(startTime)
        xTime.text = converToTimeString(rTime)
    }

    // Update O-Player time
    private func updateOTimeLabel(t: Timer? = nil){
        var rTime = runOTime
        rTime += Date().timeIntervalSince(stopTime)
        oTime.text = converToTimeString(rTime)
        // If one player, make a computermove after 1 sec
        if noOfPlayers == 1 && Date().timeIntervalSince(stopTime) >= 1 {
            let nextCompMove = theGame.compPlayerMove()
            imageTapped(y: nextCompMove.0, x: nextCompMove.1)
        }
    }

    // Covert seconds to MM:SS
    private func converToTimeString(_ sek: Double) -> String {
        var rc = ""
        var sec = Int(sek)
        var min = sec / 60
        sec = sec % 60
        min = min % 60
        
        if sec < 10 {
            rc = ":0" + String(sec)
        } else {
            rc = ":" + String(sec)
        }
        
        if min < 10 {
            rc = "0" + String(min) + rc
        } else {
            rc = String(min) + rc
        }
        
        return rc
    }
    
//    ----------------------------------------------------------------
//    |  Usear interaction                                            |
//    ----------------------------------------------------------------
    
    // Click on button play again
    @IBAction func clickPlayAgian(_ sender: UIButton) {
        theGame.startNewGame()
        startGame()
    }
    
    //Click on matrix y:1 x:1
    @IBAction func tapp11(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img11.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 0)
        }
    }
    
    //Click on matrix y:1 x:2
    @IBAction func tapp12(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img12.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 1)
        }
    }
    
    //Click on matrix y:1 x:3
    @IBAction func tapp13(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img13.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 2)
        }
    }
    
    //Click on matrix y:2 x:1
    @IBAction func tapp21(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img21.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 0)
        }
    }
    
    //Click on matrix y:2 x:2
    @IBAction func tapp22(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img22.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 1)
        }
    }
    
    //Click on matrix y:2 x:3
    @IBAction func tapp23(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img23.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 2)
        }
    }
    
    //Click on matrix y:3 x:1
    @IBAction func tapp31(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img31.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 0)
        }
    }
    
    //Click on matrix y:3 x:3
   @IBAction func tapp32(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img32.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 1)
        }
    }
    
    //Click on matrix y:3 x:3
    @IBAction func tapp33(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img33.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 2)
        }
    }

    //Compere if two images are the same
    func imageCompare(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    //Handeling user input
    func imageTapped(y: Int, x: Int){
        if !theGame.endGame {
            yourTurnLabel.text = "Your Turn"
            if theGame.nextMoveX(y: y, x: x) {
                reslabel.text = "O - player"
                let moves = theGame.playerMoves
                xMoves.text = String(moves.xPlayer)
                oMoves.text = String(moves.oPlayer)
                cordMap[y][x].image = xImg
                if let xTimer = xTimer {
                    xTimer.invalidate()
                }
                stopTime = Date()
                runXTime += stopTime.timeIntervalSince(startTime)
                oTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateOTimeLabel(t:))
                if theGame.endGame {
                    gameEnded(winner: "X")
                }
            } else {
                reslabel.text = "X - player"
                let moves = theGame.playerMoves
                xMoves.text = String(moves.xPlayer)
                oMoves.text = String(moves.oPlayer)
                cordMap[y][x].image = oImg
                if let otimer = oTimer {
                    otimer.invalidate()
                }
                startTime = Date()
                runOTime += startTime.timeIntervalSince(stopTime)
                xTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateXTimeLabel(t:))
                if theGame.endGame {
                    gameEnded(winner: "O")
                }
            }
        }
    }
    
    //Cleaning up timers
    deinit {
        timer?.invalidate()
        xTimer?.invalidate()
        oTimer?.invalidate()
    }
}
