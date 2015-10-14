import Foundation

@objc(FabricCrashlytics)
class FabricCrashlytics: CDVPlugin {
    private func frame(command: CDVInvokedUrlCommand, _ proc: () -> Void) {
        proc()
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    private func logmsg(command: CDVInvokedUrlCommand, _ proc: () -> Void = { }) {
        frame(command) {
            if let v = command.arguments.first {
                let msg = String(v)
                CLSLogv("%@", getVaList([msg]))
            }
            proc()
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
        let key = command.arguments[0] as! String
        let value = command.arguments[1] as! Bool
        frame(command) {
            Crashlytics.sharedInstance().setBoolValue(value, forKey: key)
        }
    }
    
    func setDouble(command: CDVInvokedUrlCommand) {
        let key = command.arguments[0] as! String
        let value = command.arguments[1] as! Float64
        frame(command) {
            Crashlytics.sharedInstance().setObjectValue(value, forKey: key)
        }
    }
    
    func setFloat(command: CDVInvokedUrlCommand) {
        let key = command.arguments[0] as! String
        let value = command.arguments[1] as! Float32
        frame(command) {
            Crashlytics.sharedInstance().setFloatValue(value, forKey: key)
        }
    }
    
    func setInt(command: CDVInvokedUrlCommand) {
        let key = command.arguments[0] as! String
        let value = command.arguments[1] as! Int32
        frame(command) {
            Crashlytics.sharedInstance().setIntValue(value, forKey: key)
        }
    }
    
    func setUserIdentifier(command: CDVInvokedUrlCommand) {
        let value = command.arguments[0] as! String
        frame(command) {
            Crashlytics.sharedInstance().setUserIdentifier(value)
        }
    }
    
    func setUserName(command: CDVInvokedUrlCommand) {
        let value = command.arguments[0] as! String
        frame(command) {
            Crashlytics.sharedInstance().setUserName(value)
        }
    }
    
    func setUserEmail(command: CDVInvokedUrlCommand) {
        let value = command.arguments[0] as! String
        frame(command) {
            Crashlytics.sharedInstance().setUserEmail(value)
        }
    }
}
