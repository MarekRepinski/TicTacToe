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
    private var pMatrix: [[String]]
    private var wLine: [(y: Int, x: Int)]
    private var gameEnds: Bool
    
    init(isXstarting: Bool = true){
        self.isXstarting = isXstarting
        self.gameTurn = 0
        self.pMatrix = [["", "", ""], ["", "", ""], ["", "", ""]]
        self.wLine = [(-1, -1), (-1, -1), (-1, -1)]
        self.gameEnds = false
    }
    
    var endGame: Bool {
        return gameEnds
    }
    
    var winningLine: [(y: Int, x: Int)] {
        return wLine
    }
    
    func startNewGame(){
        gameTurn = 0
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
        gameEnds = checkEndGame()
        if player == "X" {
            return true
        } else {
            return false
        }
    }
    
    private func resetMatrix(){
        for y in 0...2 {
            for x in 0...2 {
                pMatrix[y][x] = ""
            }
        }
    }
    
    private func checkEndGame() -> Bool{
        for i in 0...2 {
            if pMatrix[i][0] != "" {
                if pMatrix[i][0] == pMatrix[i][1] && pMatrix[i][0] == pMatrix[i][2]{
                    wLine = [(i, 0), (i, 1), (i, 2)]
                    return true
                }
            }
            if pMatrix[0][i] != "" {
                if pMatrix[0][i] == pMatrix[1][i] && pMatrix[0][i] == pMatrix[2][i]{
                    wLine = [(0, i), (1, i), (2, i)]
                    return true
                }
            }
        }
        //Diagonal
        if pMatrix[0][0] != "" {
            if pMatrix[0][0] == pMatrix[1][1] && pMatrix[0][0] == pMatrix[2][2]{
                wLine = [(0, 0), (1, 1), (2, 2)]
                return true
            }
        }
        if pMatrix[0][2] != "" {
            if pMatrix[0][2] == pMatrix[1][1] && pMatrix[0][2] == pMatrix[2][0]{
                wLine = [(0, 2), (1, 1), (2, 0)]
                return true
            }
        }

        if gameTurn >= 9 {
            return true
        }
        return false
    }
}
