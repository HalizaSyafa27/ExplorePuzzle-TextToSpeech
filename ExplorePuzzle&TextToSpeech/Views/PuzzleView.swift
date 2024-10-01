//
//  PuzzleView.swift
//  ExplorePuzzle&TextToSpeech
//
//  Created by Haliza Syafa Oktaviani on 14/08/24.
//

import SwiftUI
import PhotosUI

struct PuzzleView: View {
    
    let originalTiles: [[PuzzleTile]]
    @State var selectedPhotoItem: UIImage?
    @State private var puzzleImage: UIImage?
    @State private var orderedTiles: [[PuzzleTile]]?
    @State private var shuffledTiles: [[PuzzleTile]]?
    @State private var userWon = false
    @State private var loadingImage = false
    @State private var loadedPuzzle = false
    @State private var showHint = false
    @State private var moves = 0
    private let tileSpacing = 5.0
    
    var body: some View {
        VStack {
            if loadedPuzzle, let shuffledTiles, let puzzleImage {
                
                HStack(spacing: 20) {
                    movesCountView()
                    
                    Spacer()
                    
                    puzzleHintToggleView()
                }
                .padding([.top, .horizontal], 20)
                .font(.system(size: 20))
                
                puzzleHintView(puzzleImage)
                
                puzzleView(shuffledTiles)
                    .padding()
                    .alert("🏆", isPresented: $userWon) {}
            }
        }
        .background {
            Color.white
                .ignoresSafeArea()
        }
        
        .foregroundStyle(.white)
        .font(.title)
        .onAppear(perform: {
            if self.selectedPhotoItem != nil {
                reset()
                loadingImage = true
                loadedPuzzle = false
                
                do {
                    let (image, tiles) = try PuzzleLoader().loadPuzzleFromItem(self.selectedPhotoItem)
                    puzzleImage = image
                    orderedTiles = tiles.0
                    shuffledTiles = tiles.1
                    
                    loadedPuzzle = true
                }
                catch {
                    loadedPuzzle = false
                    print(error.localizedDescription)
                }
                
                loadingImage = false
            }
            
        })
    }
    
    @ViewBuilder private func movesCountView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                Text("\(moves)")
                    .monospaced()
            }
            
            
        }
        .foregroundStyle(Color.black)
    }
    
    @ViewBuilder private func puzzleHintToggleView() -> some View {
        VStack {
            Button(action: {
                withAnimation {
                    showHint.toggle()
                }
            }, label: {
                Image(systemName: showHint ? "eye.circle.fill" : "eye.slash.circle.fill")
            })
        }
        .foregroundStyle(Color.orange)
    }
    
    @ViewBuilder private func puzzleHintView(_ image: UIImage?) -> some View {
        if showHint {
            PuzzleTileView(tile: PuzzleTile(image: image))
                .frame(width: 200, height: 200)
                .animation(.linear, value: showHint)
        }
    }
    
    @ViewBuilder private func puzzleView(_ tiles: [[PuzzleTile]]) -> some View {
        GeometryReader { geo in
            VStack(spacing: tileSpacing) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: tileSpacing) {
                        ForEach(0..<3, id: \.self) { column in
                            let tile = tiles[row][column]
                            PuzzleTileView(tile: tile)
                                .frame(width: (geo.size.width - (tileSpacing*2)) / 3,
                                       height: (geo.size.width - (tileSpacing*2)) / 3)
                                .onTapGesture {
                                    tappedTile(row: row, column: column)
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func reset() {
        moves = 0
        userWon = false
        loadedPuzzle = false
        puzzleImage = nil
        orderedTiles = nil
        shuffledTiles = nil
    }
}

extension PuzzleView {
    enum Direction {
        case up, down, left, right
    }
    
    private func tappedTile(row: Int, column: Int) {
        guard userWon == false else { return }
        guard var shuffledTiles = shuffledTiles else { return }
        guard shuffledTiles[row][column].isSpareTile == false else { return }
        
        
        if let spareTileIndex = findAdjacentSpareTile(to: (row, column)) {
            
            moves += 1
            let tappedTile = shuffledTiles[row][column]
            shuffledTiles[row][column] = shuffledTiles[spareTileIndex.0][spareTileIndex.1]
            shuffledTiles[spareTileIndex.0][spareTileIndex.1] = tappedTile
            
            self.shuffledTiles = shuffledTiles
            userWon = self.shuffledTiles == orderedTiles
        }
    }
    
    private func findAdjacentSpareTile(to tileIndex: (Int, Int)) -> (Int, Int)? {
        let directions: [Direction] = [.up, .down, .left, .right]
        
        for direction in directions {
            let adjacentTileIndex = getAdjacentTileIndex(from: tileIndex, direction: direction)
            if isValidIndex(adjacentTileIndex), shuffledTiles?[adjacentTileIndex.0][adjacentTileIndex.1].isSpareTile ?? false {
                return adjacentTileIndex
            }
        }
        
        return nil
    }
    
    private func getAdjacentTileIndex(from tileIndex: (Int, Int), direction: Direction) -> (Int, Int) {
        switch direction {
        case .up:
            return (tileIndex.0 - 1, tileIndex.1)
        case .down:
            return (tileIndex.0 + 1, tileIndex.1)
        case .left:
            return (tileIndex.0, tileIndex.1 - 1)
        case .right:
            return (tileIndex.0, tileIndex.1 + 1)
        }
    }
    
    private func isValidIndex(_ tileIndex: (Int, Int)) -> Bool {
        guard let shuffledTiles = shuffledTiles else { return false }
        return tileIndex.0 >= 0 && tileIndex.0 < shuffledTiles.count &&
        tileIndex.1 >= 0 && tileIndex.1 < shuffledTiles[tileIndex.0].count
    }
}

extension View {
    public func foregroundLinearGradient(colors: [Color],
                                         startPoint: UnitPoint,
                                         endPoint: UnitPoint) -> some View {
        self.overlay {
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(self)
        }
    }
}

//import SwiftUI
//
//struct PuzzleView: View {
//    let originalTiles: [[PuzzleTile]]
//    @State private var shuffledTiles: [[PuzzleTile]]
//    @State private var moves = 0
//    @State private var userWon = false
//    @State private var showHint = false
//    private let tileSpacing = 5.0
//
//    init(originalTiles: [[PuzzleTile]], shuffledTiles: [[PuzzleTile]]) {
//        self.originalTiles = originalTiles
//        self._shuffledTiles = State(initialValue: shuffledTiles)
//    }
//
//    var body: some View {
//        VStack {
//            HStack(spacing: 20) {
//                movesCountView()
//                
//                Spacer()
//                
//                puzzleHintToggleView()
//            }
//            .padding([.top, .horizontal], 20)
//            .font(.system(size: 20))
//            
//            puzzleHintView()
//            
//            puzzleGridView()
//                .padding()
//                .alert("🏆", isPresented: $userWon) {}
//        }
//        .background(Color.white.ignoresSafeArea())
//        .foregroundStyle(.white)
//        .font(.title)
//    }
//    
//    @ViewBuilder private func movesCountView() -> some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
//                Text("\(moves)")
//                    .monospaced()
//            }
//        }
//        .foregroundStyle(Color.black)
//    }
//    
//    @ViewBuilder private func puzzleHintToggleView() -> some View {
//        VStack {
//            Button(action: {
//                withAnimation {
//                    showHint.toggle()
//                }
//            }, label: {
//                Image(systemName: showHint ? "eye.circle.fill" : "eye.slash.circle.fill")
//            })
//        }
//        .foregroundStyle(Color.orange)
//    }
//    
//    @ViewBuilder private func puzzleHintView() -> some View {
//        if showHint, let image = originalTiles.first?.first?.image {
//            PuzzleTileView(tile: PuzzleTile(image: image))
//                .frame(width: 200, height: 200)
//                .animation(.linear, value: showHint)
//        }
//    }
//    
//    @ViewBuilder private func puzzleGridView() -> some View {
//        GeometryReader { geo in
//            VStack(spacing: tileSpacing) {
//                ForEach(0..<shuffledTiles.count, id: \.self) { row in
//                    HStack(spacing: tileSpacing) {
//                        ForEach(0..<shuffledTiles[row].count, id: \.self) { column in
//                            let tile = shuffledTiles[row][column]
//                            PuzzleTileView(tile: tile)
//                                .frame(width: (geo.size.width - (tileSpacing*2)) / 3,
//                                       height: (geo.size.width - (tileSpacing*2)) / 3)
//                                .onTapGesture {
//                                    tappedTile(row: row, column: column)
//                                }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    private func tappedTile(row: Int, column: Int) {
//        guard !userWon else { return }
//        guard shuffledTiles[row][column].isSpareTile == false else { return }
//        
//        if let spareTileIndex = findAdjacentSpareTile(to: (row, column)) {
//            moves += 1
//            let tappedTile = shuffledTiles[row][column]
//            shuffledTiles[row][column] = shuffledTiles[spareTileIndex.0][spareTileIndex.1]
//            shuffledTiles[spareTileIndex.0][spareTileIndex.1] = tappedTile
//            
//            // Langsung gunakan shuffledTiles tanpa unwrapping
//            userWon = compareTiles(shuffledTiles, to: originalTiles)
//        }
//    }
//    
//    private func findAdjacentSpareTile(to tileIndex: (Int, Int)) -> (Int, Int)? {
//        let directions: [Direction] = [.up, .down, .left, .right]
//        
//        for direction in directions {
//            let adjacentTileIndex = getAdjacentTileIndex(from: tileIndex, direction: direction)
//            if isValidIndex(adjacentTileIndex), shuffledTiles[adjacentTileIndex.0][adjacentTileIndex.1].isSpareTile {
//                return adjacentTileIndex
//            }
//        }
//        
//        return nil
//    }
//    
//    private func getAdjacentTileIndex(from tileIndex: (Int, Int), direction: Direction) -> (Int, Int) {
//        switch direction {
//        case .up:
//            return (tileIndex.0 - 1, tileIndex.1)
//        case .down:
//            return (tileIndex.0 + 1, tileIndex.1)
//        case .left:
//            return (tileIndex.0, tileIndex.1 - 1)
//        case .right:
//            return (tileIndex.0, tileIndex.1 + 1)
//        }
//    }
//    
//    private func isValidIndex(_ tileIndex: (Int, Int)) -> Bool {
//        return tileIndex.0 >= 0 && tileIndex.0 < shuffledTiles.count &&
//        tileIndex.1 >= 0 && tileIndex.1 < shuffledTiles[tileIndex.0].count
//    }
//    
//    private func compareTiles(_ tiles1: [[PuzzleTile]], to tiles2: [[PuzzleTile]]) -> Bool {
//        guard tiles1.count == tiles2.count else { return false }
//        for (rowIndex, row) in tiles1.enumerated() {
//            for (colIndex, tile) in row.enumerated() {
//                if tile.image != tiles2[rowIndex][colIndex].image {
//                    return false
//                }
//            }
//        }
//        return true
//    }
//    
//    enum Direction {
//        case up, down, left, right
//    }
//}


