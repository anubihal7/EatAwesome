//
//  RecordAudioViewController.swift
//  Berlin Club App
//
//  Created by Atinder Kaur on 7/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import QuartzCore
import BottomPopup

protocol getAudioProtocol
{
    func getFilePathAudio(fileURL:URL)
}

class RecordAudioViewController: BottomPopupViewController,RecorderDelegate
{
    
    @IBOutlet weak var voiceRecordHUD: VoiceRecordHUD!
    var recording: Recording!
    var recordDuration = 0
    @IBOutlet weak var viewBGMic: UIView!
    @IBOutlet weak var lblRecordingTime: UILabel!
    @IBOutlet weak var btnStartEnd: UIButton!
    @IBOutlet weak var lblTapToStart: UILabel!
    var delegateAudioRecorder: getAudioProtocol?
    
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(600) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.6 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.6 }
    override var popupDimmingViewAlpha: CGFloat { return 0.6 }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView()
    {
        self.title = "Record Audio"
        voiceRecordHUD.backgroundColor = UIColor.clear
        createRecorder()
        cornerView(radius: 72, view: viewBGMic)
        BorderForView(width: 6, view: viewBGMic, color: UIColor.init(red: 23.0/255, green: 26.0/255, blue: 61.0/255, alpha: 1))
    }
    
    func didFinishRecording()
    {
        print(recording.url)
        DispatchQueue.main.async
            {
                self.delegateAudioRecorder?.getFilePathAudio(fileURL:self.recording.url)
                self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func play() {
        do {
            try recording.play()
        } catch {
            print(error)
        }
    }
    
    
    func createRecorder() {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
        let dateTimePrefix: String = formatter.string(from: Date())
        
        
        recording = Recording(to: "\(dateTimePrefix).m4a")
        recording.delegate = self
        
        DispatchQueue.global().async {
            // Background thread
            do {
                try self.recording.prepare()
            } catch {
                print(error)
            }
        }
    }
    
    open func startRecording() {
        recordDuration = 0
        do {
            try recording.record()
        } catch {
            print(error)
        }
    }
    
    func audioMeterDidUpdate(_ db: Float) {
        print("db level: %f", db)
        self.recording.recorder?.updateMeters()
        let ALPHA = 0.05
        let peakPower = pow(10, (ALPHA * Double((self.recording.recorder?.peakPower(forChannel: 0))!)))
        var rate: Double = 0.0
        if (peakPower <= 0.2) {
            rate = 0.2
        } else if (peakPower > 0.9) {
            rate = 1.0
        } else {
            rate = peakPower
        }
        
        voiceRecordHUD.update(CGFloat(rate))
        voiceRecordHUD.fillColor = UIColor.init(red: 24/255, green: 174/255, blue: 122/255, alpha: 1)
        recordDuration += 1
        
        let min = Int((self.recording.recorder?.currentTime)! / 60)
        let sec = Int((self.recording.recorder?.currentTime.truncatingRemainder(dividingBy: 60))!)
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        
        if (min >= 01)
        {
            self.showToastSwift(alrtType: .error, msg: "You have reached a maximum recording limit.", title: kOops)
            recording.stop()
        }
    }
    
    
    @IBAction func actionStartEndAudio(_ sender: UIButton)
    {
        
        if  lblRecordingTime.text != "00:00"
        {
            self.didFinishRecording()
            recordDuration = 0
            recording.stop()
            voiceRecordHUD.update(00.00)
            lblRecordingTime.text = "00:00"
            btnStartEnd.setImage(UIImage(named: "recordplay"), for: .normal)
            lblTapToStart.text = "Tap to Start"
        }
            
        else
        {
            self.startRecording()
            btnStartEnd.setImage(UIImage(named: "recordpause"), for: .normal)
            lblTapToStart.text = "Tap to Finish"
        }
    }
    
    
}
