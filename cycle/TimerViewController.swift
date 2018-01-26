//
//  ViewController.swift
//  cycle
//
//  Created by camel_yang on 10/7/17.
//  Copyright © 2017 camelcc. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController {
    @IBOutlet weak var nameLabel: NSTextField? = nil

    private var tickTimer: Timer? = nil

    override func viewDidAppear() {
        super.viewDidAppear()

        tickTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.5), repeats: true) { timer in
            self.nameLabel?.stringValue = self.remainTime(CycleTimer.instance.remainingTime)
        }
    }

    override func viewDidDisappear() {
        tickTimer?.invalidate()
        tickTimer = nil
    }

    private func remainTime(_ timeInterval: TimeInterval) -> String {
        let time = Int(timeInterval)
        let hour = time / 3600
        let min = time / 60
        let sec = time % 60
        if hour == 0 {
            return String(format: "%02d:%02d", arguments: [min, sec])
        } else {
            return String(format: "%02d:02d:02d", arguments: [hour, min, sec])
        }
    }
}

