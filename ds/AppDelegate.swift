//
//  AppDelegate.swift
//  ds
//
//  Created by filipeisho on 31/07/2020.
//  Copyright © 2020 filipeisho. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "💨"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showSettings)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
     
    @objc func showSettings(){
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("Unable to find ViewController in the storyboard")
        }
        vc.presentAsModalWindow(vc)
        vc.view.window?.title = "breathe💨"
        vc.view.window?.titlebarAppearsTransparent = true
        vc.view.window?.styleMask.remove(.resizable)
        //vc.view.window?.titleVisibility = .hidden
        vc.view.window?.styleMask.insert(.fullSizeContentView)
        vc.view.window?.isOpaque = false
        vc.view.window?.backgroundColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        vc.view.window?.setFrameOrigin(NSPoint(x:0,y:0))
    }

}

