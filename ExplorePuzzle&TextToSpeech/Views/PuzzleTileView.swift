import SwiftUI

struct PuzzleTileView: View {
    let tile: PuzzleTile
    
    var body: some View {
        VStack{
            if let image = tile.image{
                    Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else{
                Color.white
            }
        }
        .overlay{
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

//#Preview {
//    PuzzleTileView(tile: PuzzleTile(image: nil, isSpareTile: true))
//}
