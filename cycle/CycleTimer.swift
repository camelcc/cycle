//
// Created by camel_yang on 12/13/17.
// Copyright (c) 2017 camelcc. All rights reserved.
//

import Foundation
import AppKit
import os.log

protocol CycleActivityDelegate: class {
    func onRestStart()
    func onWorkStart()
    func onTimerReset()
}

class CycleTimer {
    static let instance = CycleTimer()

    weak var activityDelegate: CycleActivityDelegate? = nil

    private var tickTimer: Timer? = nil

    private var isResting = false

    private var workStartTime = Date()

    var isInitialSetup: Bool {
        get {
            return NSUserDefaultsController.shared.defaults.bool(forKey: "CONFIG")
        }
        set(configed) {
            return NSUserDefaultsController.shared.defaults.set(configed, forKey: "CONFIG")
        }
    }

    var bootEnabled: Bool {
        get {
            return existingItem(itemUrl: Bundle.main.bundleURL) != nil
        }
        set(boot) {
            setLaunchAtLogin(itemUrl: Bundle.main.bundleURL, enabled: boot)
        }
    }
    var workInterval: TimeInterval {
        get {
            return TimeInterval(NSUserDefaultsController.shared.defaults.double(forKey: "WORK_TIME"))
        }
        set(rest) {
            NSUserDefaultsController.shared.defaults.set(rest, forKey: "WORK_TIME")
        }
    }
    var restInterval: TimeInterval {
        get {
            return TimeInterval(NSUserDefaultsController.shared.defaults.double(forKey: "REST_TIME"))
        }
        set(rest) {
            NSUserDefaultsController.shared.defaults.set(rest, forKey: "REST_TIME")
        }
    }

    var remainingTime: TimeInterval {
        get {
            let timePassed = -workStartTime.timeIntervalSinceNow
            if (timePassed >= workInterval && timePassed < restInterval + workInterval) {
                return TimeInterval(restInterval + workInterval - timePassed)
            } else {
                return TimeInterval(0)
            }
        }
    }

    private init() {
        if workInterval == 0 {
            workInterval = 45 * 60
        }
        if restInterval == 0 {
            restInterval = 5 * 60
        }

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(systemWillSleep), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(systemDidWake), name: NSWorkspace.didWakeNotification, object: nil)
    }

    func reset() {
        tickTimer?.invalidate()
        tickTimer = nil

        isResting = false
        workStartTime = Date()
        tickTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.5), repeats: true) { timer in
            self.tick()
        }

        self.activityDelegate?.onTimerReset()
    }

    func stop() {
        isResting = false
        tickTimer?.invalidate()
        tickTimer = nil
    }

    private func tick() {
        let timePassed = -workStartTime.timeIntervalSinceNow
        if (timePassed < workInterval) {
        } else if (timePassed >= workInterval && timePassed < restInterval + workInterval) {
            if (!isResting) {
                os_log("start resting")
                self.activityDelegate?.onRestStart()
                isResting = true
            }
        } else {
            if (isResting) {
                os_log("start working")
                isResting = false
                workStartTime = Date()
                self.activityDelegate?.onWorkStart()
            }
        }
    }

    @objc private func systemWillSleep() {
    }

    @objc private func systemDidWake() {
        os_log("cycle syste did wake")
        let timePassed = -workStartTime.timeIntervalSinceNow
        if (timePassed >= restInterval + workInterval) {
            os_log("activity happened too long ago, reset everything.")
            reset()
        }
    }
}
