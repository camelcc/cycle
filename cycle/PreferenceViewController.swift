//
// Created by camel_yang on 12/22/17.
// Copyright (c) 2017 camelcc. All rights reserved.
//

import Cocoa
import os.log

class PreferenceViewController: NSViewController, NSComboBoxDelegate {
    @IBOutlet weak var bootEnabled: NSButton!
    @IBOutlet weak var workTime: NSComboBox!
    @IBOutlet weak var restTime: NSComboBox!

    private let workTimers: [Double: String] = [25 * 60.0: "25 mins",
                                                30 * 60.0: "30 mins",
                                                45 * 60.0: "45 mins",
                                                60 * 60.0: "1 hour",
                                                120 * 60.0: "2 hour"]
    private let restTimers: [Double: String] = [60.0: "1 min",
                                                2 * 60.0: "2 mins",
                                                3 * 60.0: "3 mins",
                                                5 * 60.0: "5 mins",
                                                10 * 60.0: "10 mins",
                                                15 * 60.0: "15 mins",
                                                30 * 60.0: "30 mins"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let workTimersSorted = workTimers.sorted { $0.key < $1.key }
        self.workTime.addItems(withObjectValues: workTimersSorted.map({$0.value}))
        self.workTime.numberOfVisibleItems = workTimers.count
        if let workItem = workTimersSorted.map({$0.key}).index(of: CycleTimer.instance.workInterval) {
            self.workTime.selectItem(at: workItem)
        } else {
            self.workTime.selectItem(at: 2)
            CycleTimer.instance.workInterval = TimeInterval(45 * 60)
        }
        self.workTime.delegate = self

        let restTimersSorted = restTimers.sorted { $0.key < $1.key }
        self.restTime.addItems(withObjectValues: restTimersSorted.map({$0.value}))
        self.restTime.numberOfVisibleItems = restTimers.count
        if let restItem = restTimersSorted.map({$0.key}).index(of: CycleTimer.instance.restInterval) {
            self.restTime.selectItem(at: restItem)
        } else {
            self.restTime.selectItem(at: 3)
            CycleTimer.instance.restInterval = TimeInterval(5 * 60)
        }
        self.restTime.delegate = self

        self.bootEnabled.state = CycleTimer.instance.bootEnabled ? .on : .off
    }

    @IBAction func bootClicked(_ sender: NSButton) {
        CycleTimer.instance.bootEnabled = (self.bootEnabled.state == NSControl.StateValue.on)
    }

    @IBAction func close(_ sender: NSButton) {
        self.view.window?.close()
    }

    public func comboBoxSelectionDidChange(_ notification: Notification) {
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }

        if (comboBox == workTime) {
            let workTimersSorted = workTimers.sorted { $0.key < $1.key }
            CycleTimer.instance.workInterval = TimeInterval(workTimersSorted.map({$0.key})[workTime.indexOfSelectedItem])
            CycleTimer.instance.reset()
        } else if (comboBox == restTime) {
            let restTimersSorted = restTimers.sorted { $0.key < $1.key }
            CycleTimer.instance.restInterval = TimeInterval(restTimersSorted.map({$0.key})[restTime.indexOfSelectedItem])
            CycleTimer.instance.reset()
        }
    }
}
