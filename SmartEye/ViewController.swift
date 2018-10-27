//
//  ViewController.swift
//  SmartEye
//
//  Created by Sultan Sidhu on 2018-10-26.
//  Copyright © 2018 Sultan Sidhu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate {

    
    @IBOutlet weak var chosenImage: UIImageView!
    
    @IBAction func browseLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            var imagePicker = UIImagePickerController();
            imagePicker.delegate = self;
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true;
            
        }
    }
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            var imagePicker = UIImagePickerController();
            imagePicker.delegate = self;
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false;
            
            //self.presentedViewController(imagePicker, animated: true, completion: nil);
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage;
        chosenImage.image = image;
        dismiss(animated: true, completion: nil);
        
    }
    
    func getChosenImage() -> UIImage?{
        if (chosenImage.image != nil){
            return chosenImage.image
            // returns a UIImage object.
        } else {
            print("The image has not been chosen");
            return nil;
        }
    }
    
    
    // Some variables handling the audio recording
    var recordingButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSession = AVAudioSession.sharedInstance();
        do{
            //try recordingSession.setCategory(AVAudioSession.Category.playAndRecord);
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [])
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){
                [unowned self] allowed in DispatchQueue.main.async {
                    if allowed{
                        self.loadRecordingUI();
                    } else {
                        print("failed to load recordings!");
                    }
                }
            }
        } catch {
            print("failed to load recordings!");
        }
    }
    
    func loadRecordingUI(){
        recordingButton = UIButton(frame(CGRect(x: 64, y: 64, width: 128, height: 64))); 
        recordingButton.setTitle("Tap to record", for: .normal);
        recordingButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1);
        recordingButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside);
        view.addSubview(recordingButton)
    }
    
    func startRecording(){
        let audioFileName = getDocumentDirectory().appendingPathComponent("recording.m4a");
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue];
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings);
            audioRecorder.delegate = self;
            audioRecorder.record();
            
            recordingButton.setTitle("Tap to stop recording", for: .normal);
        }
        catch{
            finishRecording(success: false);
        }
    }
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        return paths[0];
    }
    
    func finishRecording(success: Bool){
        audioRecorder.stop();
        audioRecorder = nil;
        if success{
            recordingButton.setTitle("Tap to re-record", for: .normal);
        } else {
            recordingButton.setTitle("Tap to record", for: .normal);
        }
    }
    
    @objc func recordTapped(){ // the @objc tag makes the function accessible in Objective-C as well, even if marked private.
        if audioRecorder == nil{
            startRecording();
        } else {
            finishRecording(success: true);
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag{
            finishRecording(success: false);
        }
    }


}

