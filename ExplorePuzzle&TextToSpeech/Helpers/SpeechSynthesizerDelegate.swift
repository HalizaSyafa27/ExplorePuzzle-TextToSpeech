//
//  SpeechSynthesizerDelegate.swift
//  ExplorePuzzle&TextToSpeech
//
//  Created by Haliza Syafa Oktaviani on 14/08/24.
//

import Foundation
import AVFoundation

class SpeechSynthesizerDelegate: NSObject, AVSpeechSynthesizerDelegate{
    var didFinishSuccess = false
    var didFinishSpeechCallback: (() -> Void)?
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            // When speech finishes, perform some tasks
            print("Speech synthesis finished for utterance: \(utterance.speechString)")
            didFinishSuccess = true
            print(didFinishSuccess)
        
            didFinishSpeechCallback?()
        }
}
