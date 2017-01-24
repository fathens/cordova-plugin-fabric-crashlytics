import Foundation

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

    // MARK: - Cordova Commands

    @objc(log:)
    func log(command: CDVInvokedUrlCommand) {
        logmsg(command)
    }

    @objc(logException:)
    func logException(command: CDVInvokedUrlCommand) {
        logmsg(command) {
            Crashlytics.sharedInstance().throwException()
        }
    }

    @objc(crash:)
    func crash(command: CDVInvokedUrlCommand) {
        logmsg(command) {
            Crashlytics.sharedInstance().crash()
        }
    }

    @objc(setBool:)
    func setBool(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getBoolAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setBoolValue(value, forKey: key)
        }
    }

    @objc(setDouble:)
    func setDouble(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getDoubleAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setObjectValue(value, forKey: key)
        }
    }

    @objc(setFloat:)
    func setFloat(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getFloatAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setFloatValue(value, forKey: key)
        }
    }

    @objc(setInt:)
    func setInt(command: CDVInvokedUrlCommand) {
        let key = command.getStringAt(0)
        let value = command.getIntAt(1)
        frame(command) {
            Crashlytics.sharedInstance().setIntValue(value, forKey: key)
        }
    }

    @objc(setUserIdentifier:)
    func setUserIdentifier(command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserIdentifier(value)
        }
    }

    @objc(setUserName:)
    func setUserName(command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserName(value)
        }
    }

    @objc(setUserEmail:)
    func setUserEmail(command: CDVInvokedUrlCommand) {
        let value = command.getStringAt(0)
        frame(command) {
            Crashlytics.sharedInstance().setUserEmail(value)
        }
    }

    // MARK: - Private Utillities

    fileprivate func fork(_ proc: @escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async(execute: proc)
    }

    fileprivate func frame(_ command: CDVInvokedUrlCommand, _ proc: @escaping () throws -> Void) {
        fork {
            do {
                try proc()
                self.commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
            } catch (let ex) {
                self.commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: ex.localizedDescription), callbackId: command.callbackId)
            }
        }
    }

    fileprivate func logmsg(_ command: CDVInvokedUrlCommand, _ proc: @escaping () -> Void = {}) {
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
}
