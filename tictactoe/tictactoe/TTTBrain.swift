//
//  TTTBrain.swift
//  tictactoe
//
//  Created by admin on 12.11.22.
//

import SwiftUI

class TTTBrain: ObservableObject {
   @Published var searchPlayer = ""
   @Published var spielBrett: [String?] = Array(repeating: nil, count: 9)
   var spielerX = true
   @Published var showAlert = false
    let succesSequences: Set<Set<Int>> = [
    [0,3,6], [1,4,7], [2,5,8],
    [0,1,2], [3,4,5],[6,7,8],
    [0,4,8], [2,4,6]
    ]
    //Speichert den Zug und schaut ob das Spiel zuende ist
    func saveMove(position: Int, mode: String){
        if (mode == "1vs1"){
            spielBrett[position] = spielerX ? "X" : "O"
            spielerX.toggle()
                    for player in ["X","O"]{
                        if checkWinner(player: player){
                            showAlert = true
                            return
                        }
                        else if(movesLeft().count == 0 && !checkWinner(player: "0") && !checkWinner(player: "X")){
                            searchPlayer = "Tie Game!!"
                            showAlert = true
                            return
                        }
                    }
        }
        else{
            spielBrett[position] = "X"
            if(checkWinner(player: "X")){
                showAlert=true
                return
            }
            botMov(mode: mode)
            if(checkWinner(player: "0")){
                showAlert=true
                return
            }
            if (movesLeft().count == 0 && !checkWinner(player: "0") && !checkWinner(player: "X")){
                searchPlayer = "Tie Game!!"
                showAlert = true
            }
        }
    }
    
    func botMov(mode: String){
        let amountMoves = movesLeft()
        if(amountMoves.count != 0){
            if(mode == "easy"){
                 spielBrett[amountMoves.randomElement() ?? 0] = "0"
            }
            else if(mode == "normal"){
                spielBrett[evalute()] = "0"
            }
        }
    }
    // Evaluiert den Zug
    func evalute()->Int{
        // Schaut, wo eine Gewinnchance besteht
        for sequence in succesSequences {
            let winPosition = sequence.subtracting(botPosition())
            if winPosition.count == 1{
                for position in movesLeft(){
                    if winPosition.first == position {
                        return winPosition.first!
                    }
                }
            }
        }
        //Schaut, wo Spielerzug blockiert wird
        for sequence in succesSequences {
            let blockPosition = sequence.subtracting(playersPosition())
            if blockPosition.count == 1{
                for position in movesLeft(){
                    if blockPosition.first == position {
                        return blockPosition.first!
                    }
                }
            }
        }
        return movesLeft().randomElement() ?? 0
        
    }
    // Positionen die noch keiner gespielt hat
    func movesLeft() -> [Int]{
        var amountMoves: [Int] = []
        var counter = 0
        for move in spielBrett{
            if move == nil{
                amountMoves.append(counter)
            }
            counter += 1
        }
        return amountMoves
    }
    //Besetze Position von Computer
    func botPosition() -> Set<Int>{
        var computerPosition: Set<Int> = []
        var counter = 0
        for move in spielBrett{
            if move == "0"{
                computerPosition.insert(counter)
                counter += 1
            }
            else{
                counter += 1
            }
        }
        return computerPosition
    }
    //Besetze Position von Spieler
    func playersPosition() -> Set<Int>{
        var playerPosition: Set<Int> = []
        var counter = 0
        for move in spielBrett{
            if move == "X"{
                playerPosition.insert(counter)
                counter += 1
            }
            else{
                counter += 1
            }
        }
        return playerPosition
    }
    // Überprüft wer gewinnt
    func checkWinner(player:String)-> Bool {
        for sequence in succesSequences {
            var hit = 0
            for match in sequence{
                if spielBrett[match] == player{
                    hit += 1
                    if hit == 3 {
                        searchPlayer = "Player " + player + " has won!"
                        return true
                    }
                }
            }
        }
        return false
        
    }
    
    func zug(columnRange: Int, row: Int, column: Int, mode: Binding<String>){
        let position = columnRange * row + column
        if spielBrett[position] == nil {
            saveMove(position: position, mode: mode.wrappedValue)
            }
        }
    
    // Setzt Spiel wieder auf Anfang
    func resetGame(){
        spielBrett = Array(repeating: nil, count: 9)
    }
}

