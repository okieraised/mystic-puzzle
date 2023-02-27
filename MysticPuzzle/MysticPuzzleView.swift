//
//  ContentView.swift
//  MysticPuzzle
//
//  Created by Tri Pham on 2/23/23.
//

import SwiftUI


struct MysticPuzzleView: View {
    @StateObject var mysticPuzzleViewModel: MysticPuzzleViewModel = MysticPuzzleViewModel()
    
    let title = "Mystic Puzzle"
    let newGamePrompt = "New Game"
    let shufflePrompt = "Shuffle"
    let easyGamePrompt = "Easy Game"
    let tileDimension: CGFloat = 70
    
    var body: some View {
        ZStack {
            Image("WaterBackground")
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack {
                ChalkBoardTextView(text: title, size: 42, color: .white)
                
                ZStack {
                    let tiles = mysticPuzzleViewModel.mysticPuzzleModel.tiles
                    let last = mysticPuzzleViewModel.mysticPuzzleModel.tiles.count - 1
                    
                    ForEach(0..<last) { index in
                        let tile = mysticPuzzleViewModel.mysticPuzzleModel.tiles[index]
                        
                    
                        TileView(tileNumber: tile.value, tileDimension: tileDimension, offset: tile.currentPoint)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    if mysticPuzzleViewModel.move(index: index) {
                                        playSound(sound: "mixkit-glass-plate-slide-1527", type: "wav")
                                    }
                                }   
                            }
                    }  
                }
                .frame(width: tileDimension * 4, height: tileDimension * 4)
                .padding()
                .background(
                    Image("BlueMarbleBackground")
                        .resizable()
                        .opacity(0.5)
                )
                .cornerRadius(20)
                .padding()
                .padding(.vertical)
                .shadow(color: .black, radius: 10, x: 3, y: 3)
                
                HStack {
                    Button {
                        mysticPuzzleViewModel.createInitialItems()
                        mysticPuzzleViewModel.shuffle()
                    } label: {
                        ChalkBoardTextView(text: mysticPuzzleViewModel.done() ? newGamePrompt : shufflePrompt, size: 24, color: .yellow)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.yellow, lineWidth: 3)
                            )
                            .padding(.vertical)
                    }
                    
                    Button {
                        mysticPuzzleViewModel.createInitialItems()
                    } label: {
                        ChalkBoardTextView(text: easyGamePrompt, size: 24, color: .green)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.green, lineWidth: 3)
                            )
                            .padding(.vertical)
                    }
                }
            }
        }
    }
}

struct ChalkBoardTextView: View {
    
    let text: String
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Text(text)
            .font(Font.custom("ChalkboardSE-Bold", size: size))
            .fontWeight(.bold)
            .foregroundColor(color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MysticPuzzleView()
    }
}

struct TileView: View {
    let tileNumber: Int
    let tileDimension: CGFloat
    let offset: CGPoint
    let padding: CGFloat = 3
    let digitResizeFactor: CGFloat = 0.8
    
    var body: some View {
        let direction = offset * tileDimension
        
        let deltaX = direction.x + tileDimension / 2
        let deltaY = direction.y - 3 * tileDimension / 2
        
        
        Image("digit\(tileNumber)")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.red)
            .aspectRatio(contentMode: .fit)
            .frame(width: tileDimension * digitResizeFactor, height: tileDimension * digitResizeFactor)
            .scaleEffect(tileNumber < 10 || tileNumber == 11 ? 0.8 : 1.0)
            .padding()
            .background(
                Image("MarbleTileBackground")
                    .resizable()
                    .frame(width: tileDimension - padding, height: tileDimension - padding)
                    .cornerRadius(10)
            )
            .offset(x: deltaX, y: deltaY)
            .shadow(color: .black, radius: 1, x: 1, y: 1)
    }
}
