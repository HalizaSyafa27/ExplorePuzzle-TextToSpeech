//
//  HelpView.swift
//  ExplorePuzzle&TextToSpeech
//
//  Created by Haliza Syafa Oktaviani on 14/08/24.
//

import SwiftUI
import AVFAudio

struct HelpView: View {
    var tm = TextToSpeechManager()
    private let textToSpeak = "Demensia merupakan istilah umum, menggambarkan gejala yang terjadi ketika otak dipengaruhi oleh penyakit atau kondisi tertentu. Ada berbagai jenis demensia, meskipun ada beberapa yang lebih umum daripada yang lain karena sering dinamai sesuai dengan kondisi yang telah menyebabkan demensia tersebut"
    
    
    var body: some View {
        NavigationStack{
            VStack {

                Text("Help")
                  Button(action: {
                      // Memanggil metode speak untuk membacakan teks
                      tm.speak(textToSpeak)
                  }) {
                      Image(systemName: "speaker.wave.2.circle.fill")
                          .resizable()
                          .frame(width: 40, height: 40)
                          .foregroundColor(.black)
                  }
                  .padding()
              }
          }
    }
}

#Preview {
    HelpView()
}
