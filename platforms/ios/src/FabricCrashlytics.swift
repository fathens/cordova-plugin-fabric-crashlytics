import Foundation
import Cordova
import Fabric
import Crashlytics

extension CDVInvokedUrlCommand {
    func getStringAt(_ index: UInt) -> String {
        return argument(at: index) as! String
    }

    func getDoubleAt(_ index: UInt) -> Double {
        return (argument(at: index) as AnyObject).doubleValue
    }

    func getFloatAt(_ index: UInt) -> Float {
        return (argument(at: index) as AnyObject).floatValue
    }

    func getIntAt(_ index: UInt) -> Int32 {
        return (argument(at: index) as AnyObject).int32Value
    }

    func getBoolAt(_ index: UInt) -> Bool {
        return argument(at: index) as! Bool
    }
}

@objc(FabricCrashlytics)
class FabricCrashlytics: CDVPlugin {
    fileprivate func frame(_ command: CDVInvokedUrlCommand, _ proc: () -> Void) {
        proc()
        commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }

    fileprivate func logmsg(_ command: CDVInvokedUrlCommand, _ proc: () -> Void = {}) {
        frame(command) {
            if let v = command.arguments.first {
                if (!(v is NSNull)) {
                    let msg = String(describing: v).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    if (!msg.isEmpty) {
                        CLSLogv("%@", getVaList([msg]))
                    }
                }
            }
            proc()
        }
    }

    func log(_ command: CDVInvokedUrlCommand) {
        logmsg(command)
    }

    func logException(_ command: CDVInvokedUrlCommand) {
        logmsg(command) {
            Crashlytics.sharedInstance().throwException()
        }
    }

    func crash(_ command: CDVInvokedUrlCommand) {
        logmsg(command) {
            Crashlytics.sharedInstance().crash()
        }
    }

    func setBool(_ command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getBoolAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setBoolValue(value, forKey: key)
        }
    }

    func setDouble(_ command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getDoubleAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setObjectValue(value, forKey: key)
        }
    }

    func setFloat(_ command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getFloatAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setFloatValue(value, forKey: key)
        }
    }

    func setInt(_ command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getIntAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setIntValue(value, forKey: key)
        }
    }

    func setUserIdentifier(_ command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserIdentifier(value)
        }
    }

    func setUserName(_ command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserName(value)
        }
    }

    func setUserEmail(_ command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserEmail(value)
        }
    }
}
