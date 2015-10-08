import Foundation

@objc(FabricCrashlytics)
class FabricCrashlytics: CDVPlugin {
    func log(command: CDVInvokedUrlCommand) {
        func msg() -> String {
            if let v = command.arguments.first {
                return String(v)
            } else {
                return ""
            }
        }
        CLSLogv("%@", getVaList([msg()]));
        
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    func logException(command: CDVInvokedUrlCommand) {
        func msg() -> String {
            if let v = command.arguments.first {
                return String(v)
            } else {
                return ""
            }
        }
        CLSLogv("%@", getVaList([msg()]));
        Crashlytics.sharedInstance().throwException()
        
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
}
