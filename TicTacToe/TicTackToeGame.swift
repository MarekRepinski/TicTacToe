//
//  TicTackToeGame.swift
//  TicTacToe
//  Main app (Model)
//
//  Created by Marek Repinski on 2020-12-16.
//

import Foundation

class TicTackToeGame {
    private var isXstarting: Bool                           // True if X-player starts
    private var gameTurn: Int                               // Number of moves in game so far
    private var xTurn: Int                                  // No. of X-player moves in game
    private var oTurn: Int                                  // No. of O-player moves in game
    private var pMatrix: [[String]]                         // TicTacToe matrix
    private var wLine: [(y: Int, x: Int)]                   // Winning line
    private var gameEnds: Bool                              // True if game ended
    private var xPlayerWins: Int                            // No. fo wins for X-player
    private var oPlayerWins: Int                            // No. fo wins for O-player
    private var gamePath: Int                               // used by Computer player AI
    
    init(isXstarting: Bool = true){
        self.isXstarting = isXstarting
        self.gameTurn = 0
        self.pMatrix = [["", "", ""], ["", "", ""], ["", "", ""]]
        self.wLine = [(-1, -1), (-1, -1), (-1, -1)]
        self.gameEnds = false
        self.xPlayerWins = 0
        self.oPlayerWins = 0
        self.xTurn = 0
        self.oTurn = 0
        self.gamePath = 0
    }
    
    var playerMoves: (xPlayer: Int, oPlayer: Int){          // Returns no of moves for each player
        return (xTurn, oTurn)
    }
    
    var xStart: Bool {                                      // Returns true if X-player starts
        return isXstarting
    }
    
    var playerWins: (xPlayer: Int, oPlayer: Int){           // Returns no of wins for each player
        return (xPlayerWins, oPlayerWins)
    }
    
    var endGame: Bool {                                     // Returns true if game ended
        return gameEnds
    }
    
    var winningLine: [(y: Int, x: Int)] {                   // Returns the winning line
        return wLine
    }
    
    // Start a new game
    func startNewGame(){
        gameTurn = 0
        xTurn = 0
        oTurn = 0
        resetMatrix()
        wLine = [(-1, -1), (-1, -1), (-1, -1)]
        gameEnds = false
    }
    
    // Called from Controller: set matrix and return true if X-player move
    func nextMoveX(y: Int, x: Int) -> Bool{
        gameTurn += 1
        if gameTurn % 2 == 1 {
            if isXstarting {
                return nextMove(y: y, x: x)
            }
        } else {
            if !isXstarting {
                return nextMove(y: y, x: x)
            }
        }
        return nextMove(y: y, x: x, player: "O")
    }
    
    // Set TicTacToe matrix and return true if X-player move
    private func nextMove(y: Int, x: Int, player: String = "X") -> Bool{
        pMatrix[y][x] = player
        if player == "X" {
            xTurn += 1
            gameEnds = checkEndGame()
            return true
        }
        oTurn += 1
        gameEnds = checkEndGame(xPLayer: false)
        return false
    }
    
    // Reset TicTacToe matrix
    private func resetMatrix(){
        for y in 0...2 {
            for x in 0...2 {
                pMatrix[y][x] = ""
            }
        }
    }
    
    // Check if the game is ended
    private func checkEndGame(xPLayer: Bool = true) -> Bool{
        for i in 0...2 {
            if pMatrix[i][0] != "" {
                if pMatrix[i][0] == pMatrix[i][1] && pMatrix[i][0] == pMatrix[i][2]{
                    wLine = [(i, 0), (i, 1), (i, 2)]
                    addWins(xPLayer: xPLayer)
                    return true
                }
            }
            if pMatrix[0][i] != "" {
                if pMatrix[0][i] == pMatrix[1][i] && pMatrix[0][i] == pMatrix[2][i]{
                    wLine = [(0, i), (1, i), (2, i)]
                    addWins(xPLayer: xPLayer)
                    return true
                }
            }
        }
        //Diagonal
        if pMatrix[0][0] != "" {
            if pMatrix[0][0] == pMatrix[1][1] && pMatrix[0][0] == pMatrix[2][2]{
                wLine = [(0, 0), (1, 1), (2, 2)]
                addWins(xPLayer: xPLayer)
                return true
            }
        }
        if pMatrix[0][2] != "" {
            if pMatrix[0][2] == pMatrix[1][1] && pMatrix[0][2] == pMatrix[2][0]{
                wLine = [(0, 2), (1, 1), (2, 0)]
                addWins(xPLayer: xPLayer)
                return true
            }
        }

        if gameTurn >= 9 {
            isXstarting = !isXstarting
            return true
        }
        return false
    }
    
    // Add wins to player
    private func addWins(xPLayer: Bool){
        if xPLayer {
            xPlayerWins += 1
            isXstarting = false
        } else {
            oPlayerWins += 1
            isXstarting = true
        }
    }
    
    //    ----------------------------------------------------------------
    //    |  Computer player AI                                          |
    //    ----------------------------------------------------------------
        
    func compPlayerMove() -> (y: Int, x: Int){
        var pos = (-1, -1)
        if !isXstarting {
            switch gameTurn {
            case 0:
                return (2, 0)
            case 2:
                if pMatrix[0][2] == "X" {
                    gamePath = 1
                    return (0, 0)
                } else if pMatrix[0][0] == "X" || pMatrix[2][2] == "X" {
                    gamePath = 2
                    return (0, 2)
                } else if pMatrix[1][1] == "X" {
                    gamePath = 3
                    return (0, 2)
                } else {
                    gamePath = 4
                    return (1, 1)
                }
            case 4:
                pos = canWinLose(token: "O")
                if pos.0 != -1 {
                    return pos
                }
                pos = canWinLose(token: "X")
                if pos.0 != -1 {
                        return pos
                } else if gamePath == 1 {
                    return (2, 2)
                } else if gamePath == 2 {
                    if pMatrix[0][0] == "X" {
                        return (2, 2)
                    }
                    return (0, 0)
                } else if gamePath == 3 {
                    return canWinLose(token: "X")
                } else if gamePath == 4 {
                    if pMatrix[2][1] != "X" {
                        return (2, 2)
                    }
                    return (0, 0)
                }
            default:
                pos = canWinLose(token: "O")
                if pos.0 != -1 {
                    return pos
                }
                pos = canWinLose(token: "X")
                if pos.0 != -1 {
                    return pos
                }
                return randPos()
            }
        } else {
            switch gameTurn {
            case 1:
                if pMatrix[1][1] == "X" {
                    gamePath = 1
                    return (2, 0)
                } else {
                    if pMatrix[0][0] == "X" || pMatrix[0][2] == "X" ||  pMatrix[2][0] == "X" ||  pMatrix[2][2] == "X" {
                        gamePath = 2
                    } else {
                        gamePath = 3
                    }
                    return (1, 1)
                }
            case 3:
                pos = canWinLose(token: "O")
                if pos.0 != -1 {
                    return pos
                }
                pos = canWinLose(token: "X")
                if pos.0 != -1 {
                    return pos
                } else if gamePath == 1 {
                    return (2, 2)
                } else if gamePath == 2 {
                    if pMatrix[0][0] == "X" && pMatrix[2][2] == "X" || pMatrix[0][2] == "X" && pMatrix[2][2] == "X"{
                        return (0, 1)
                    } else {
                        gamePath = 5
                        if pMatrix[0][0] == "X"{
                            if pMatrix[1][2] == "X"{
                                return (0, 1)
                            } else {
                                return (1, 0)
                            }
                        } else if pMatrix[0][2] == "X"{
                            if pMatrix[2][1] == "X"{
                                return (1, 2)
                            } else {
                                return (0, 1)
                            }
                        } else if pMatrix[2][0] == "X"{
                            if pMatrix[0][1] == "X"{
                                return (1, 0)
                            } else {
                                return (2, 1)
                            }
                        } else {
                            if pMatrix[1][0] == "X"{
                                return (2, 1)
                            } else {
                                return (1, 2)
                            }
                        }
                    }
                } else if gamePath == 3 {
                    if pMatrix[0][1] == "X" {
                        if pMatrix[2][1] == "X" {
                            gamePath = 4
                            return (1, 0)
                        } else if pMatrix[1][0] == "X" {
                            return (0, 0)
                        } else if pMatrix[1][2] == "X" {
                            return (0, 2)
                        } else if pMatrix[2][0] == "X" {
                            return (1, 0)
                        } else if pMatrix[2][2] == "X" {
                            return (1, 2)
                        }
                    } else if pMatrix[1][0] == "X" {
                        if pMatrix[1][2] == "X" {
                            gamePath = 4
                            return (0, 1)
                        } else if pMatrix[2][1] == "X" {
                            return (2, 0)
                        } else if pMatrix[0][2] == "X" {
                            return (0, 1)
                        } else if pMatrix[2][2] == "X" {
                            return (2, 1)
                        }
                    } else if pMatrix[1][2] == "X" {
                        if pMatrix[2][1] == "X" {
                            return (2, 2)
                        } else if pMatrix[0][0] == "X" {
                            return (0, 1)
                        } else if pMatrix[2][0] == "X" {
                            return (2, 1)
                        }
                    } else if pMatrix[2][1] == "X" {
                        if pMatrix[0][0] == "X" {
                            return (1, 0)
                        } else if pMatrix[0][2] == "X" {
                            return (1, 2)
                        }
                    }
                }
                pos = canWinLose(token: "O", pressure: true)
                if pos.0 != -1 {
                    return pos
                }
                return randPos()
            case 5:
                pos = canWinLose(token: "O")
                if pos.0 != -1 {
                    return pos
                }
                pos = canWinLose(token: "X")
                if pos.0 != -1 {
                    return pos
                }
                if gamePath == 4 {
                    return (0, 0)
                } else if gamePath == 5 {
                    if pMatrix[0][2] == "X" && pMatrix[0][1] == "" || pMatrix[2][0] == "X" && pMatrix[1][0] == "" {
                        return (0,0)
                    }
                    if pMatrix[0][0] == "X" && pMatrix[0][1] == "" || pMatrix[2][2] == "X" && pMatrix[1][2] == "" {
                        return (0,2)
                    }
                    if pMatrix[0][0] == "X" && pMatrix[1][0] == "" || pMatrix[2][2] == "X" && pMatrix[2][1] == "" {
                        return (2,0)
                    }
                    return (2,2)
                } else {
                    pos = canWinLose(token: "O", pressure: true)
                    if pos.0 != -1 {
                        return pos
                    }
                    return randPos()
                }
            default:
                pos = canWinLose(token: "O")
                if pos.0 != -1 {
                    return pos
                }
                pos = canWinLose(token: "X")
                if pos.0 != -1 {
                    return pos
                }
                pos = canWinLose(token: "O", pressure: true)
                if pos.0 != -1 {
                    return pos
                }
                return randPos()
            }
        }
        return randPos()
    }
    
    private func randPos() -> (y: Int, x: Int){
        var cnt = 0
        var rc = (-1, -1)
        var yTemp = 0
        var xTemp = 0
        
        while rc.0 == -1 && cnt < 10000 {
            cnt += 1
            yTemp = Int.random(in: 0...2)
            xTemp = Int.random(in: 0...2)
            if pMatrix[yTemp][xTemp] == "" {
                rc = (yTemp, xTemp)
            }
        }
        return rc
    }
    
    private func canWinLose(token: String, pressure: Bool = false) -> (y: Int, x: Int){
        var pos = -1
        for i in 0...2 {
            pos = canWinLoseCheck(pMatrix[i][0], pMatrix[i][1], pMatrix[i][2], token, pressure: pressure)
            if pos != -1 {
                return (i, pos)
            }
            pos = canWinLoseCheck(pMatrix[0][i], pMatrix[1][i], pMatrix[2][i], token, pressure: pressure)
            if pos != -1 {
                return (pos, i)
            }
        }
        
        //Diagonal check
        pos = canWinLoseCheck(pMatrix[0][0], pMatrix[1][1], pMatrix[2][2], token, pressure: pressure)
        if pos != -1 {
            return (pos, pos)
        }
        pos = canWinLoseCheck(pMatrix[0][2], pMatrix[1][1], pMatrix[2][0], token, pressure: pressure)
        if pos != -1 {
            return (pos, (2 - pos))
        }

        return (-1, -1)
    }
    
    private func canWinLoseCheck(_ a: String, _ b: String, _ c: String, _ check: String, pressure: Bool = false) -> Int {
        var hit = 0
        var empty = 0
        var pos = 0
        
        if a == check{
            hit += 1
        }
        if b == check{
            hit += 1
        }
        if c == check{
            hit += 1
        }
        if a == ""{
            empty += 1
        }
        if b == ""{
            pos = 1
            empty += 1
        }
        if c == ""{
            pos = 2
            empty += 1
        }
        if !pressure {
            if hit == 2 && empty == 1 {
                return pos
            }
        } else {
            if hit == 1 && empty == 2 {
                return pos
            }
        }
        return -1
    }
}
