//
//  TicTackToeGame.swift
//  TicTacToe
//
//  Created by Marek Repinski on 2020-12-16.
//

import Foundation

class TicTackToeGame {
    private var isXstarting: Bool
    private var gameTurn: Int
    private var xTurn: Int
    private var oTurn: Int
    private var pMatrix: [[String]]
    private var wLine: [(y: Int, x: Int)]
    private var gameEnds: Bool
    private var xPlayerWins: Int
    private var oPlayerWins: Int
    private var gamePath: Int
    
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
    
    var playerMoves: (xPlayer: Int, oPlayer: Int){
        return (xTurn, oTurn)
    }
    
    var xStart: Bool {
        return isXstarting
    }
    
    var playerWins: (xPlayer: Int, oPlayer: Int){
        return (xPlayerWins, oPlayerWins)
    }
    
    var endGame: Bool {
        return gameEnds
    }
    
    var winningLine: [(y: Int, x: Int)] {
        return wLine
    }
    
    func startNewGame(){
        gameTurn = 0
        xTurn = 0
        oTurn = 0
        resetMatrix()
        wLine = [(-1, -1), (-1, -1), (-1, -1)]
        gameEnds = false
    }
    
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
    
    private func resetMatrix(){
        for y in 0...2 {
            for x in 0...2 {
                pMatrix[y][x] = ""
            }
        }
    }
    
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
    
    private func addWins(xPLayer: Bool){
        if xPLayer {
            xPlayerWins += 1
            isXstarting = false
        } else {
            oPlayerWins += 1
            isXstarting = true
        }
    }
    
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
