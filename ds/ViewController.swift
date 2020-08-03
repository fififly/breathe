//
//  ViewController.swift
//  ds
//
//  Created by filipeisho on 31/07/2020.
//  Copyright © 2020 filipeisho. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBAction func ToggleSettings(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
               guard let vc = storyboard.instantiateController(withIdentifier: "SettingsController") as? SettingsController else {
                   fatalError("Unable to find ViewController in the storyboard")
               }
               vc.presentAsModalWindow(vc)
               vc.view.window?.title = "breathe settings💨"
               vc.view.window?.titlebarAppearsTransparent = true
               vc.view.window?.styleMask.remove(.resizable)
               //vc.view.window?.titleVisibility = .hidden
               vc.view.window?.styleMask.insert(.fullSizeContentView)
               vc.view.window?.isOpaque = false
               vc.view.window?.backgroundColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
               vc.view.window?.setFrameOrigin(NSPoint(x:0,y:0))
    }
    @IBOutlet weak var coloredView: GraphView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
            self.deflate()
        }
     
    }
    
    func inflate(){
        self.view.window?.backgroundColor = NSColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 0.85)
        NSAnimationContext.runAnimationGroup({_ in
         NSAnimationContext.beginGrouping()
             NSAnimationContext.current.duration = 4.0
             var origin = self.coloredView.frame.origin
             origin.x -= 20
             origin.y -= 20

             self.coloredView.animator().setFrameOrigin(origin)
             
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 4.0
            var size = self.coloredView.frame.size
            size.height *= 2
            size.width *= 2
            self.coloredView.animator().setFrameSize(size)

            NSAnimationContext.endGrouping()
       
            NSAnimationContext.endGrouping()
        }, completionHandler:{
                   self.hold_after_inflate()
            })
        
    }

    func hold_after_inflate(){
        self.view.window?.backgroundColor = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.85)

           NSAnimationContext.runAnimationGroup({_ in
                  NSAnimationContext.beginGrouping()
                      NSAnimationContext.current.duration = 4.0
                      var origin = self.coloredView.frame.origin
                      origin.x -= 0.0000001
                      self.coloredView.animator().setFrameOrigin(origin)
                      
                     NSAnimationContext.beginGrouping()
                     NSAnimationContext.current.duration = 4.0
                     var size = self.coloredView.frame.size
                     size.height *= 1.00000001
                     size.width *= 1.00000001
                     self.coloredView.animator().setFrameSize(size)

                     NSAnimationContext.endGrouping()
                
                     NSAnimationContext.endGrouping()
                 }, completionHandler:{
                            self.deflate()
                     })
      }

    
    func deflate(){
        self.view.window?.backgroundColor = NSColor(red: 0.1, green: 0.1, blue: 0.5, alpha: 0.85)
        NSAnimationContext.runAnimationGroup({_ in
         NSAnimationContext.beginGrouping()
             NSAnimationContext.current.duration = 4.0
             var origin = self.coloredView.frame.origin
             origin.x += 20
             origin.y += 20
            self.coloredView.animator().setFrameOrigin(origin)
             
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 4.0
            var size = self.coloredView.frame.size
            size.height *= 0.5
            size.width *= 0.5
            self.coloredView.animator().setFrameSize(size)
            
            NSAnimationContext.endGrouping()
            NSAnimationContext.endGrouping()
        }, completionHandler:{
                self.hold_after_deflate()
            })
        
    }
  
   func hold_after_deflate(){
    self.view.window?.backgroundColor = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.85)

         NSAnimationContext.runAnimationGroup({_ in
                NSAnimationContext.beginGrouping()
                    NSAnimationContext.current.duration = 4.0
                    var origin = self.coloredView.frame.origin
                    origin.x -= 0.0000001
                    self.coloredView.animator().setFrameOrigin(origin)
                    
                   NSAnimationContext.beginGrouping()
                   NSAnimationContext.current.duration = 4.0
                   var size = self.coloredView.frame.size
                   size.height *= 1.00000001
                   size.width *= 1.00000001
                   self.coloredView.animator().setFrameSize(size)

                   NSAnimationContext.endGrouping()
              
                   NSAnimationContext.endGrouping()
               }, completionHandler:{
                          self.inflate()
                   })
    }
 


   
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
       
    }
    
   
    override var representedObject: Any? {
        didSet {
        }
    }
    


}
