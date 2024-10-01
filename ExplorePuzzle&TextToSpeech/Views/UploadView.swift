//
//  PuzzleView.swift
//  ExplorePuzzle&TextToSpeech
//
//  Created by Haliza Syafa Oktaviani on 14/08/24.
//

import SwiftUI

struct UploadView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var puzzleImage: UIImage?
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .ignoresSafeArea(.all)
                
                if let selectedImage = inputImage {
                    // Menampilkan PuzzleView jika gambar sudah dipilih
                    if let originalTiles = generateTiles(from: selectedImage) {
                                        PuzzleView(originalTiles: originalTiles, selectedPhotoItem: selectedImage)
                                    } else {
                                        Text("Failed to load puzzle")
                                            .foregroundColor(.red)
                                    }
                } else {
                    // Menampilkan ikon untuk memilih gambar
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .frame(width: 121, height: 119)
                        .foregroundStyle(Color.black)
                        .padding(.top, 200)
                        .onTapGesture {
                            self.showImagePicker = true
                        }
                        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                            ImagePicker(sourceType: .photoLibrary, image: self.$inputImage)
                        }
                }
            }
        }
    }
    
     func loadImage() {
        guard let inputImage = inputImage else { return }
        self.puzzleImage = inputImage
        self.image = Image(uiImage: inputImage)
    }
     func generateTiles(from image: UIImage) -> [[PuzzleTile]]? {
        do {
            let puzzleLoader = PuzzleLoader()
//            let (croppedImage, (originalTiles, _)) = try puzzleLoader.loadPuzzleFromItem(image)
            let (_, (originalTiles, _)) = try puzzleLoader.loadPuzzleFromItem(image)
            return originalTiles
        } catch {
            print("Error generating tiles: \(error)")
            return nil
        }
    }

}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
