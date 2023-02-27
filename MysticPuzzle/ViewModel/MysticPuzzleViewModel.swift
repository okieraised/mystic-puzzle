//
//  MysticPuzzleViewModel.swift
//  MysticPuzzle
//
//  Created by Tri Pham on 2/23/23.
//

import Foundation
import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer? = AVAudioPlayer()

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioPlayer?.play()
        } catch {
            print("Something wrong")
        }
    }
}

class MysticPuzzleViewModel: ObservableObject {
    @Published var mysticPuzzleModel: MysticPuzzleModel = MysticPuzzleModel(tiles: [], n: 0) {
        didSet {
            saveItems()
        }
    }
    
    let itemKey = "Tile List"
    
    init() {
        guard let data = UserDefaults.standard.data(forKey: itemKey),
                let savedItems = try? JSONDecoder().decode(MysticPuzzleModel.self, from: data)
        else {
            self.createInitialItems()
            self.shuffle()
            return
        }
        
        self.mysticPuzzleModel = savedItems
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(mysticPuzzleModel) {
            UserDefaults.standard.set(encodedData, forKey: itemKey)
        }
    }
    
    func createInitialItems() {
        var tiles: [TileModel] = []
        tiles.append(
        TileModel(value: 1,
                  currentPoint: LEFT * 2,
                  winningPoint: LEFT * 2)
        )
        tiles.append(
        TileModel(value: 2,
                  currentPoint: LEFT * 1,
                  winningPoint: LEFT * 1)
        )
        tiles.append(
        TileModel(value: 3,
                  currentPoint: .zero,
                  winningPoint: .zero)
        )
        
        tiles.append(
        TileModel(value: 4,
                  currentPoint: RIGHT * 1,
                  winningPoint: RIGHT * 1)
        )
        tiles.append(
        TileModel(value: 5,
                  currentPoint: LEFT * 2 + DOWN,
                  winningPoint: LEFT * 2 + DOWN)
        )
        tiles.append(
        TileModel(value: 6,
                  currentPoint: LEFT * 1 + DOWN,
                  winningPoint: LEFT * 1 + DOWN)
        )
        tiles.append(
        TileModel(value: 7,
                  currentPoint: DOWN,
                  winningPoint: DOWN)
        )
        
        tiles.append(
        TileModel(value: 8,
                  currentPoint: RIGHT * 1 + DOWN,
                  winningPoint: RIGHT * 1 + DOWN)
        )
        tiles.append(
        TileModel(value: 9,
                  currentPoint: LEFT * 2 + DOWN * 2,
                  winningPoint: LEFT * 2 + DOWN * 2)
        )
        tiles.append(
        TileModel(value: 10,
                  currentPoint: LEFT * 1 + DOWN * 2,
                  winningPoint: LEFT * 1 + DOWN * 2)
        )
        tiles.append(
        TileModel(value: 11,
                  currentPoint: DOWN * 2,
                  winningPoint: DOWN * 2)
        )
        
        tiles.append(
        TileModel(value: 12,
                  currentPoint: RIGHT * 1 + DOWN * 2,
                  winningPoint: RIGHT * 1 + DOWN * 2)
        )
        tiles.append(
        TileModel(value: 13,
                  currentPoint: LEFT * 2 + DOWN * 3,
                  winningPoint: LEFT * 2 + DOWN * 3)
        )
        tiles.append(
        TileModel(value: 14,
                  currentPoint: LEFT * 1 + DOWN * 3,
                  winningPoint: LEFT * 1 + DOWN * 3)
        )
        tiles.append(
        TileModel(value: 15,
                  currentPoint: DOWN * 3,
                  winningPoint: DOWN * 3)
        )
        tiles.append(
        TileModel(value: 16,
                  currentPoint: RIGHT * 1 + DOWN * 3,
                  winningPoint: RIGHT * 1 + DOWN * 3)
        )
        
        let n = 4
        
        self.mysticPuzzleModel = MysticPuzzleModel(tiles: tiles, n: n)
    }
    
    func shuffle() {
        let n = mysticPuzzleModel.n
        for _ in 0..<n*n {
            let (i, j) = getRandomIJ(max: n*n - 1)
            
            let lastPosition = mysticPuzzleModel.tiles[i].currentPoint
            mysticPuzzleModel.tiles[i].currentPoint = mysticPuzzleModel.tiles[j].currentPoint
            mysticPuzzleModel.tiles[j].currentPoint = lastPosition
        }
    }
    
    func getRandomIJ(max: Int) -> (Int, Int) {
        if max == 1 {
            return (1, 1)
        }
        
        let i = Int.random(in: 0..<max)
        var j: Int
        
        repeat {
            j = Int.random(in: 0..<max)
        } while (i == j)
        
        return (i, j)
    }
    
    func move(index: Int) -> Bool {
        var result = false
        
        let n = mysticPuzzleModel.n
        let emptyPosition = mysticPuzzleModel.tiles[n * n - 1].currentPoint
        
        let tilePostition = mysticPuzzleModel.tiles[index].currentPoint
        let distance = tilePostition.distanceTo(point: emptyPosition)
        
        if distance == 1 {
            mysticPuzzleModel.tiles[index] = TileModel(value: mysticPuzzleModel.tiles[index].value,
                                                       currentPoint: emptyPosition,
                                                       winningPoint: mysticPuzzleModel.tiles[index].winningPoint)
            
            mysticPuzzleModel.tiles[n * n - 1].currentPoint = tilePostition
            
            result = true
        }
        
        return result
    }
    
    func done() -> Bool {
        for tile in mysticPuzzleModel.tiles {
            if tile.currentPoint != tile.winningPoint {
                return false
            }
        }
        return true
    }
}
