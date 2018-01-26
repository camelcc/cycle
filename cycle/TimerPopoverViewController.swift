//
//  TimerPopover.swift
//  cycle
//
//  Created by camel_yang on 12/23/17.
//  Copyright © 2017 camelcc. All rights reserved.
//

import Cocoa

class TimerPopoverViewController: NSViewController {
    var timerLabel: NSTextField?

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.autoresizingMask = [.width, .height]
        timerLabel = NSTextField(frame: CGRect.zero)
        if let timerLabel = self.timerLabel {
            timerLabel.translatesAutoresizingMaskIntoConstraints = false

            timerLabel.stringValue = "00:00:00"
            timerLabel.isBezeled = false
            timerLabel.isEditable = false
            timerLabel.isSelectable = false
            timerLabel.drawsBackground = false
            self.view.addSubview(timerLabel)

//            let centerX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: timerLabel, attribute: .centerX, multiplier: 1.0, constant: 0)
//            let centerY = NSLayoutConstraint(item: self.view, attribute: .centerY, relatedBy: .equal, toItem: timerLabel, attribute: .centerY, multiplier: 1.0, constant: 0)
//            let width = NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .equal, toItem: timerLabel, attribute: .width, multiplier: 1.0, constant: 0)
//            let height = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: timerLabel, attribute: .height, multiplier: 1.0, constant: 0)
//            timerLabel.addConstraints([centerX, centerY, width, height])
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        CycleTimer.instance.delegate = self
    }

    override func viewDidDisappear() {
        CycleTimer.instance.delegate = nil
    }

    // MARK: Storyboard instantiation
    static func createViewController() -> TimerPopoverViewController {
        return TimerPopoverViewController(nibName: nil, bundle: nil)
    }
}

extension TimerPopoverViewController: CycleTimerDelegate {
    func onRestStart() {
        self.timerLabel?.stringValue = "Resting"
    }

    func onRestUpdate(_ remainingTime: TimeInterval) {
        self.timerLabel?.stringValue = "Resting \(Int(remainingTime))"
    }

    func onWorkStart() {
        self.timerLabel?.stringValue = "Working"
    }

    func onWorkUpdate(_ remainingTime: TimeInterval) {
        self.timerLabel?.stringValue = "Working \(Int(remainingTime))"
    }
}
