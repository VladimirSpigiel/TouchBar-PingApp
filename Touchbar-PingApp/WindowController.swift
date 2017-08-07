//
//  WindowController.swift
//  touchbar-pingApp
//
//  Created by Crayer/VladimirSpigiel on 01/08/2017.
//  Copyright © 2017 Crayer. All rights reserved.
//

import Cocoa
import PlainPing
import CoreWLAN

fileprivate extension NSTouchBarItemIdentifier {
    static let controlStripButton = NSTouchBarItemIdentifier(
        rawValue: "com.crayer.TouchBarItem.controlStripButton"
    )
}

class WindowController: NSWindowController {
    
    // --------------------- OUTLETS ----------------------- //
    @IBOutlet weak var nbrPingsButton: NSButton!
    @IBOutlet weak var lastPingMsg: NSTextField!
    @IBOutlet weak var togglePingButton: NSButton!
    
    // --------------------- ATTRIBUTES ----------------------- //
    let controlStripItem = NSControlStripTouchBarItem(identifier: .controlStripButton)
    
    weak var controlStripButton: NSButton? {
        set {
            // This will replace the ControlStripItem by the view given
            controlStripItem.view = newValue!
        }
        get {
            return controlStripItem.view as? NSButton
        }
    }
    
    private var isPinging : Bool = false
    private let START_TEXT : String = "\u{25B6}"
    private let STOP_TEXT : String = "\u{25A0}"
    var timer : Timer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

    // --------------------- OVERRIDES ----------------------- //
    override func windowDidLoad() {
        super.windowDidLoad()
        
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        createControlStripButton()
        
        // Need to be performed after the creation of ControlStripButton
        controlStripItem.isPresentInControlStrip = true;
        
        lastPingMsg.isHidden = true;
        nbrPingsButton.isHidden = true;
        togglePingButton.title = START_TEXT
    
    }
    
    
    // --------------------- PUBLIC METHODS ----------------------- //
    public func presentModalTouchBar() {
        
        if #available(OSX 10.12.2, *) {
            touchBar?.presentAsSystemModal(for: controlStripItem)
            startPing();
            
        }
    }
    
    
    // --------------------- PRIVATE METHODS ----------------------- //
    private func createControlStripButton(){
        controlStripButton = NSButton(
            title: "\u{0001F310}",
            target: self,
            action: #selector(presentModalTouchBar))
    }
    
    func netInfo() -> String{
        // This function returns a formated string as :  SSID:RSSI
        
        let iface : CWInterface? = CWWiFiClient()?.interface(withName: nil)
        let ssid :String? = iface?.ssid()
        let rssi :String? = String(iface?.rssiValue() ?? 0)
        return (ssid ?? "Error") + ":" + (rssi ?? "Error")
    }
    
    
    func pinging(){
        // Set the Touchbar UI's button with the SSID:RSSI info
        nbrPingsButton.title = netInfo()
        
        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            
            // When we got a latency, just show how much ms inside the touchbar's textfield
            if let latency = timeElapsed {
                self.lastPingMsg.textColor = NSColor.green
                self.lastPingMsg.stringValue = "Latency : \(Int(latency))ms"
            }
            
            // When we got an error, display it in the touchbar's textfield too
            if let error = error {
                self.lastPingMsg.textColor = NSColor.red
                let index = error.localizedDescription.index(error.localizedDescription.startIndex, offsetBy: 40)
                self.lastPingMsg.stringValue = "Error : \(error.localizedDescription.substring(to: index)) ..."
            }
        })
    }
    
    func startPing(){
        
        // Ensure we don't launch multiple time the timer
        if(isPinging) {stopPing()}
        
        lastPingMsg.isHidden = false;
        nbrPingsButton.isHidden = false;
        togglePingButton.title = STOP_TEXT
        timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(pinging), userInfo: nil, repeats: true)
        isPinging = true;
    }
    
    private func stopPing(){
        lastPingMsg.isHidden = true;
        nbrPingsButton.isHidden = true;
        togglePingButton.title = START_TEXT
        timer?.invalidate()
        isPinging = false;
    }
    
    private func togglePinging(){
        if !isPinging{
           startPing()
        }else{
            stopPing()
        }
    }
    
    // --------------------- UI BINDINGS ----------------------- //
    @IBAction func pingButtonClicked(_ sender: NSButton) {
        togglePinging()
    }
}
