import Foundation

extension CDVInvokedUrlCommand {
    func getStringAt(index: UInt) -> String {
        return argumentAtIndex(index) as! String
    }
    
    func getDoubleAt(index: UInt) -> Double {
        return argumentAtIndex(index).doubleValue
    }
    
    func getFloatAt(index: UInt) -> Float {
        return argumentAtIndex(index).floatValue
    }
    
    func getIntAt(index: UInt) -> Int32 {
        return argumentAtIndex(index).intValue
    }
    
    func getBoolAt(index: UInt) -> Bool {
        return argumentAtIndex(index) as! Bool
    }
}

@objc(FabricCrashlytics)
class FabricCrashlytics: CDVPlugin {
    private func frame(command: CDVInvokedUrlCommand, _ proc: () -> Void) {
        proc()
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    private func logmsg(command: CDVInvokedUrlCommand, _ proc: () -> Void = {}) {
        frame(command) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let v = command.arguments.first {
                    if (!(v is NSNull)) {
                        let msg = String(v).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        if (!msg.isEmpty) {
                            //CLSLogv("%@", getVaList([msg]))
                        }
                    }
                }
                proc()
            }
        }
    }
    
    func log(command: CDVInvokedUrlCommand) {
        logmsg(command)
    }
    
    func logException(command: CDVInvokedUrlCommand) {
        logmsg(command) {
            Crashlytics.sharedInstance().throwException()
        }
    }
    
    func crash(command: CDVInvokedUrlCommand) {
        logmsg(command) {
            Crashlytics.sharedInstance().crash()
        }
    }
    
    func setBool(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getBoolAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setBoolValue(value, forKey: key)
        }
    }
    
    func setDouble(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getDoubleAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setObjectValue(value, forKey: key)
        }
    }
    
    func setFloat(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getFloatAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setFloatValue(value, forKey: key)
        }
    }
    
    func setInt(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getIntAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setIntValue(value, forKey: key)
        }
    }
    
    func setUserIdentifier(command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserIdentifier(value)
        }
    }
    
    func setUserName(command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserName(value)
        }
    }
    
    func setUserEmail(command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserEmail(value)
        }
    }
}
