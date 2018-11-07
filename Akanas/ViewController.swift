//
//  ViewController.swift
//  Akanas
//
//  Created by Private on 2018/11/07.
//  Copyright © 2018 鵜巷. All rights reserved.
//

import AVFoundation
import Cocoa

class ViewController: NSViewController {
    
    lazy var window: NSWindow! = self.view.window
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var backgroundBox: NSBox!

    var timer: Timer = Timer()
    var remainingTime: Double = 25 * 60 + 0.9
    var currentTime: Double = Double()
    var exitTime: Double = Double()
    var counting: Bool = false
    var interval: Bool = false
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        playAudio(fileName: "cursor1")
        doAkanas()
    }

    func doAkanas() {
        if !counting {
            exitTime = remainingTime + NSDate.timeIntervalSinceReferenceDate
            timer = Timer.scheduledTimer(timeInterval: 1/10, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
        
        counting = !counting
    }
    
    func switchAkanas() {
        if !interval {
            window.title = "nas"
            backgroundBox.fillColor = NSColor(deviceCyan: 0.6, magenta: 0.41, yellow: 0, black: 0, alpha: 1)
            playAudio(fileName: "warning1")
        } else {
            window.title = "Akanas"
            backgroundBox.fillColor = NSColor(deviceCyan: 0.01, magenta: 0.72, yellow: 0.53, black: 0, alpha: 1)
            playAudio(fileName: "decision1")
        }
        
        interval = !interval
    }

    @objc func countDown() {
        remainingTime = exitTime - NSDate.timeIntervalSinceReferenceDate
        
        if remainingTime < 1.0 {
            switchAkanas()
            if interval {
                remainingTime = 5 * 60 + 0.9
            } else {
                remainingTime = 25 * 60 + 0.9
                if counting {
                    doAkanas()
                }
            }
            exitTime = remainingTime + NSDate.timeIntervalSinceReferenceDate
        }
        
        updateText()
    }

    func updateText() {
        let min = Int(remainingTime / 60)
        let sec = Int(floor(remainingTime)) % 60
        
        let minText = String(format: "%02d", min)
        let secText = String(format: "%02d", sec)
        
        timerLabel.stringValue = "\(minText):\(secText)"
    }
    
    func playAudio(fileName: String) {
        let setURL = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        
        if let selectURL = setURL {
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: selectURL, fileTypeHint: nil)
            }catch{
            }
        }
        audioPlayer?.play()
    }
}

