//
//  SettingsController.swift
//  breathe
//
//  Created by filipeisho on 02/08/2020.
//  Copyright © 2020 filipeisho. All rights reserved.
//

import Cocoa

class SettingsController: NSViewController {
    
   
    @IBOutlet weak var durationLabel: NSTextField!
    @IBOutlet weak var progressionEnabled: NSButton!
    @IBOutlet weak var increaseByStepper: NSStepper!
    @IBOutlet weak var minutesStepper: NSStepper!
    @IBOutlet weak var timesStepper: NSStepper!
    @IBOutlet weak var increaseByLabel: NSTextField!
    @IBOutlet weak var minutesLabel: NSTextField!
    @IBOutlet weak var timesLabel: NSTextField!
    @IBOutlet weak var exerciseSelector: NSPopUpButton!
    @IBOutlet weak var anchorSelector: NSPopUpButton!
    var popoverView = NSPopover.init()
    
    @IBAction func progressionEnabled(_ sender: NSButton) {
        
        self.updateProgressionValues()
    }
    
    @IBAction func increaseByWasUpdated(_ sender: NSStepper) {
         increaseByLabel.stringValue = String(sender.integerValue)
        self.updateProgressionValues()
        
    }
    @IBAction func minutesWasUpdated(_ sender: NSStepper) {
          minutesLabel.stringValue = String(sender.integerValue)
        self.updateProgressionValues()

    }
    @IBAction func timesWasUpdated(_ sender: NSStepper) {
          timesLabel.stringValue = String(sender.integerValue)
        self.updateProgressionValues()
    }
    
    
    func updateProgressionValues(){
        if self.progressionEnabled.state.rawValue == 1 {
          increaseByStepper.isEnabled = true
          minutesStepper.isEnabled = true
          timesStepper.isEnabled = true
          durationLabel.intValue = (timesLabel.intValue * minutesLabel.intValue)

        
        }
        else {
            increaseByStepper.isEnabled = false
            minutesStepper.isEnabled = false
            timesStepper.isEnabled = false
            durationLabel.intValue = 0
        }
        let propertyList = self.readPropertyList()
        propertyList["progression_enabled"] = self.progressionEnabled.state.rawValue
        propertyList["progression_increase_by"] = self.increaseByLabel.intValue
        propertyList["progression_minutes"] = self.minutesLabel.intValue
        propertyList["progression_times"] = self.timesLabel.intValue
        let filepath = applicationDocumentsDirectory().appending("/exercises.plist")
        propertyList.write(toFile: filepath, atomically: true)
    }
    
    
   @IBAction func quitBreatheWasPressed(_ sender: NSButton) {
       NSApplication.shared.terminate(self)
   }
   
   @IBAction func closeWasPressed(_ sender: Any) {
       self.view.window?.close()
   }
    @IBAction func aboutBreatheWasPressed(_ sender: NSButton) {
        guard let vc = storyboard?.instantiateController(withIdentifier: "AboutController") as? AboutController else {
            fatalError("Unable to find AboutController in the storyboard")
        }
        
        popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
    }
    
    @IBAction func NewExerciseWasPressed(_ sender: NSButton) {
        guard let vc = storyboard?.instantiateController(withIdentifier: "NewExerciseController") as? NewExerciseController else {
            fatalError("Unable to find NewExerciseController in the storyboard")
        }
        vc.delegate = self
        
        popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
    }
  
    @IBAction func adjustColorsWasPressed(_ sender: NSButton) {
        print("fs")
        guard let vc = storyboard?.instantiateController(withIdentifier: "ColorController") as? ColorController else {
            fatalError("Unable to find ColorController in the storyboard")
        }
        
        popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
    }
    
    @IBAction func exerciseSelectorWasUpdated(_ sender: NSPopUpButton) {
        self.updateBreathingConstants(exerciseTitle: sender.selectedItem?.title ?? "")
    }
    
    @IBAction func anchorWasUpdated(_ sender: NSPopUpButton) {
        let propertyList = self.readPropertyList() as NSMutableDictionary
        propertyList["anchor"] = sender.selectedItem?.title
        let filepath = applicationDocumentsDirectory().appending("/exercises.plist")
        propertyList.write(toFile: filepath, atomically: true)
    }
    
   
    
    @IBAction func deleteWasPressed(_ sender: Any) {
      
        if exerciseSelector.itemTitles.count > 1 {
           let propertyList = self.readPropertyList() as NSMutableDictionary
           let exercises = propertyList["exercises"] as! NSMutableDictionary
           exercises.removeObject(forKey: exerciseSelector.selectedItem?.title)
           propertyList["exercises"] = exercises
           let filepath = applicationDocumentsDirectory().appending("/exercises.plist")
           propertyList.write(toFile: filepath, atomically: true)
           let newExercises = propertyList["exercises"] as! [String:AnyObject]
           self.exerciseSelector.removeAllItems()
           newExercises.keys.forEach() {self.exerciseSelector.addItem(withTitle: $0) }
           propertyList["exercise"] = exerciseSelector.itemTitle(at: 0)
           exerciseSelector.selectItem(at: 0)
           self.updateBreathingConstants(exerciseTitle: exerciseSelector.itemTitle(at: 0))
        } else {
           let alert = NSAlert()
           alert.messageText = "Can't delete the last exercise"
           alert.runModal()
        }
    
    }
   
    
    func applicationDocumentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
         let basePath = paths.first ?? ""
         return basePath
     }
    func updateBreathingConstants(exerciseTitle:String){
        let propertyList = self.readPropertyList() as NSMutableDictionary
        let exercises = propertyList["exercises"] as! NSMutableDictionary
        let title = exerciseTitle
        let exercise = exercises[title] as! NSMutableDictionary
        propertyList["exercise"] = title
        propertyList["inflate"] = exercise["inflate"]
        propertyList["deflate"] = exercise["deflate"]
        propertyList["hold_after_inflate"] = exercise["hold_after_inflate"]
        propertyList["hold_after_deflate"] = exercise["hold_after_deflate"]
        let filepath = applicationDocumentsDirectory().appending("/exercises.plist")
        propertyList.write(toFile: filepath, atomically: true)
    }
    func readPropertyList()  -> NSMutableDictionary {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: NSMutableDictionary = [:] //Our data
        let plistPath = applicationDocumentsDirectory().appending("/exercises.plist")
        let plistXML = FileManager.default.contents(atPath: plistPath)!
            do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! NSMutableDictionary
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        return plistData
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        let propertyList = self.readPropertyList()
        let exercises = propertyList["exercises"] as! [String:AnyObject]
        let anchor = propertyList["anchor"] as! String
        let breathingInColorArray = propertyList["inflate_color"] as! NSDictionary
        let firstHoldingColorArray = propertyList["hold_color"] as! NSDictionary
        let breathingOutColorArray = propertyList["deflate_color"] as! NSDictionary
        self.progressionEnabled.intValue = propertyList["progression_enabled"] as! Int32
        self.increaseByLabel.intValue = propertyList["progression_increase_by"] as! Int32
        self.minutesLabel.intValue = propertyList["progression_minutes"] as! Int32
        self.timesLabel.intValue = propertyList["progression_times"] as! Int32
        self.increaseByStepper.intValue = propertyList["progression_increase_by"] as! Int32
        self.minutesStepper.intValue = propertyList["progression_minutes"] as! Int32
        self.timesStepper.intValue = propertyList["progression_times"] as! Int32
        if self.progressionEnabled.state.rawValue == 1 {
          self.durationLabel.intValue = self.timesLabel.intValue * self.minutesLabel.intValue

          increaseByStepper.isEnabled = true
          minutesStepper.isEnabled = true
          timesStepper.isEnabled = true
        }
        
        anchorSelector.selectItem(withTitle: anchor)
        exercises.keys.forEach() {self.exerciseSelector.addItem(withTitle: $0) }
        exerciseSelector.selectItem(withTitle: propertyList["exercise"] as! String)
        //self.updateBreathingConstants(exerciseTitle: propertyList["exercise"] as! String)
    }
    
    override func viewWillAppear() {
       let propertyList = self.readPropertyList()
       let exercises = propertyList["exercises"] as! [String:AnyObject]
       exercises.keys.forEach() {self.exerciseSelector.addItem(withTitle: $0) }
       exerciseSelector.selectItem(withTitle: propertyList["exercise"] as! String)
       self.updateBreathingConstants(exerciseTitle: propertyList["exercise"] as! String)

    }

     
    override func viewDidAppear() {
        super.viewDidAppear()
        //self.view.window?.level = .floating
       // self.view.window?.title = "breathe 💨 preferences"
        //self.view.window?.titlebarAppearsTransparent = true
        //self.view.window?.styleMask.remove(.resizable)
       // self.view.window?.isOpaque = false
        self.view.window?.backgroundColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        //self.view.window?.titleVisibility = .hidden
       // self.view.window?.styleMask.remove(.titled)
       
    }
   
}
