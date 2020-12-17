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
}
