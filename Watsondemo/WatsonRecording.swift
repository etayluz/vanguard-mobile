//
//  WatsonRecording.swift
//  amex
//
//  Created by dennis noto on 8/10/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//



//ETAY  - This code needs to go into the didPress xx Button event to trigger recording. All areas of integration are tagged with your name
/*

if audioRecorder == nil {
    startRecording()
} else {
    finishRecording(success: true)
}


*/
 
import Foundation
import Alamofire
import SpeechToTextV1
import AVFoundation

let appDelegate = Chat.self
var audioURL : NSURL!
var audioRecorder: AVAudioRecorder!
var recordingSession: AVAudioSession!

@objc class WatsonRecording : NSObject, AVAudioRecorderDelegate {

    var answer = ""

    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func startRecording() {
        let directory = String(getDocumentsDirectory())
        let audioFilename = (directory as NSString).stringByAppendingPathComponent("recording.wav")
        audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
 //ETAY           self.leftButton.setImage(UIImage(named: "microphone-inuse")!.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
 
// This is for setting Button to Red Color to indicate recording is on!!
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
 //ETAY           self.leftButton.setImage(UIImage(named: "microphone-normal")!.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
  
 // This is for changing the buttion back to normal non-red color
            
            // Add sending file to Watson STT
            // Take response and put in message
            // Auto click Send button
            let username = "8b772b77-c923-42ff-b2ef-29370cba1965"
            let password = "NP0ooxJSFfL8"
         
           let speechToText = SpeechToText(username: username, password: password)
            
 //already have a class named this !!!!!!!!!!!! I Fixied the old class by renameing TextToSpeech to TexttoSpeech
            
            
            // load audio file
            // guard let fileURL = NSBundle.mainBundle().URLForResource(sendaudio, withExtension: "wav") else {
            //print("Audio file could not be loaded.")
            //    return
            // }
            
            // transcribe audio file
            let settings = TranscriptionSettings(contentType: .WAV)
            let failure = { (error: NSError) in print(error) }
            speechToText.transcribe(audioURL, settings: settings, failure: failure) { results in
                let answer = results.last?.alternatives.last?.transcript as String!
                if (answer != nil) {
                    print(answer)
   //ETAY           self.textView.text = answer
   //ETAY           self.rightButton.sendActionsForControlEvents(.TouchUpInside)
   
   //  Put the Answer in the message box and simulate a push button event to simulate Send
                    
                } else {
                    print("No Answer from STT")
                }
            }
            
            
        } else {
            // recordButton.setTitle("Tap to Record", forState: .Normal)
            // recording failed
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
   

    
}