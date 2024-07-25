//
//  ContentView.swift
//  tictactoe
//
//  Created by admin on 11.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var tttBrain = TTTBrain()
    @State var gameMode = true
    var rowRange = 3
    var columnRange = 3
    @State var mode  = ""
    
    var body: some View {
            VStack() {
                Spacer()
                Text("")
                    .alert("Difficulty", isPresented: $gameMode){
                            Button("Easy AI"){
                                mode = "easy"
                            }
                            Button("Normal AI"){
                                mode = "normal"
                            }
                            Button("1vs1"){
                                mode = "1vs1"
                        }
                    }
               Spacer()
                Text("TicTacToe")
                    .font(.system(size: 35))
                    .padding()
                    .bold()
                    .foregroundColor(.cyan)
                    .frame(width:400, height:5)
                Spacer()
                    Text("")
                    .alert(tttBrain.searchPlayer, isPresented: $tttBrain.showAlert){
                        Button("Reset",role:.destructive, action: tttBrain.resetGame)
                    }
                ForEach(0..<rowRange){
                    row in HStack(alignment: .center){
                        ForEach(0..<columnRange){
                            column in
                            Button(action:{tttBrain.zug(columnRange: columnRange,row: row, column: column, mode: $mode)}){
                                    Text(tttBrain.spielBrett[columnRange * row + column] ?? "")
                                    .frame(width:100, height: 100, alignment: .center)
                                    .font(.system(size: 40))
                                    .bold()
                                    .background(.mint)
                                    .foregroundColor(.yellow)
                                    .clipShape(Rectangle()).cornerRadius(20)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                }
                Spacer()
                Button("Change Difficulty"){
                    tttBrain.resetGame()
                    gameMode = true
                }.padding()
                    .foregroundColor(.cyan)
                    .background(.yellow)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                Button(action:{tttBrain.resetGame()}){
                    Text("Reset")
                        .bold()
                        .shadow(radius: 5)
                        .foregroundColor(.mint)
                        .padding()
                        }
            }
            .background(LinearGradient(
                colors: [Color.black, Color.white],
                startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
        
}

