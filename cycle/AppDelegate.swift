//
//  AppDelegate.swift
//  cycle
//
//  Created by camel_yang on 10/7/17.
//  Copyright © 2017 camelcc. All rights reserved.
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    private var timerWindowController: NSWindowController? = nil
    private var preferenceWindowController: NSWindowController? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }

        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.addItem(withTitle: "Preferences...", action: #selector(showPreferences(_:)), keyEquivalent: ",")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        self.statusItem.menu = menu

        CycleTimer.instance.reset()
        CycleTimer.instance.activityDelegate = self

        if !CycleTimer.instance.isInitialSetup {
            CycleTimer.instance.isInitialSetup = true
            CycleTimer.instance.bootEnabled = true
            showPreferences(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        CycleTimer.instance.stop()
    }

    @objc private func showPreferences(_ sender: Any?) {
        if (preferenceWindowController == nil) {
            preferenceWindowController = instantiateControllerFromMainStoryboard(withIdentifier: "PreferenceWindowController") as? NSWindowController
        }
        guard let windowController = preferenceWindowController else {
            os_log("can not find preference window controller")
            return
        }

        windowController.window?.makeKeyAndOrderFront(sender)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func showTimer(_ sender: Any?) {
        if (timerWindowController == nil) {
            timerWindowController = instantiateControllerFromMainStoryboard(withIdentifier: "TimerWindowController") as? NSWindowController
        }
        guard let windowController = timerWindowController else {
            os_log("can not find timer window controller")
            return
        }

        windowController.window?.makeKeyAndOrderFront(sender)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func instantiateControllerFromMainStoryboard(withIdentifier controllerId: String) -> Any {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: controllerId)
        return storyboard.instantiateController(withIdentifier: identifier)
    }
}

extension AppDelegate: CycleActivityDelegate {
    func onRestStart() {
        showTimer(nil)
    }

    func onWorkStart() {
        timerWindowController?.window?.close()
    }

    func onTimerReset() {
        timerWindowController?.window?.close()
    }
}

