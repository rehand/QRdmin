//
//  Ping.swift
//  QRdmin
//
//  Created by Reinhard Handler on 23.01.16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

// this class provides ping functionality
class Ping : NSObject, SimplePingDelegate {
    let PING_TIMEOUT_SECONDS = 10.0
    let PING_COUNT = 5
    
    var canStartPinging: Bool = false
    var callback: (success: Bool) -> Void
    var timer: NSTimer?
    var pingerRef: SimplePing?
    
    init(hostNameOrIpAddress: String, callback: (success: Bool) -> Void) {
        self.callback = callback
        super.init()
        
        let pinger = SimplePing(hostName: hostNameOrIpAddress)
        self.pingerRef = pinger
        pinger.delegate = self;
        pinger.start()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(PING_TIMEOUT_SECONDS, target: self, selector: "update", userInfo: nil, repeats: true)
        
        var count = 0
        
        repeat {
            if (canStartPinging) {
                pinger.sendPingWithData(nil)
                count++
            }
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        } while(count < PING_COUNT && timer!.valid)
    }
    
    func update() {
        NSLog("Timeout reached...")
        self.finish(nil, success: false)
    }
    
    func simplePing(pinger: SimplePing!, didStartWithAddress address: NSData!) {
        NSLog("Address resolved, start pinging now...")
        canStartPinging = true
    }
    
    func simplePing(pinger: SimplePing!, didReceivePingResponsePacket packet: NSData!) {
        NSLog("Ping success!")
        self.finish(pinger, success: true)
    }
    
    func simplePing(pinger: SimplePing!, didFailWithError error: NSError!) {
        NSLog("Ping failed: " + error.localizedDescription)
        self.finish(pinger, success: false)
    }
    
    func simplePing(pinger: SimplePing!, didFailToSendPacket packet: NSData!, error: NSError!) {
        NSLog("Failed to send Packet: " + error.localizedDescription)
        self.finish(pinger, success: false)
    }

    private func finish(pinger: SimplePing?, success: Bool) {
        pinger?.stop()
        self.pingerRef?.stop()
        canStartPinging = false
        
        timer?.invalidate()
        
        self.callback(success: success)
    }
}
