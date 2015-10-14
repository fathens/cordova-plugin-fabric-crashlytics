import Foundation

@objc(FabricCrashlytics)
class FabricCrashlytics: CDVPlugin {
    private func logmsg(command: CDVInvokedUrlCommand) -> String? {
        return command.arguments.first.map {
            let msg = String($0)
            
            let alert = UIAlertController(title: "Pop by Swift", message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            viewController!.presentViewController(alert, animated: true, completion: nil)
            
            CLSLogv("%@", getVaList([msg]))
            return msg
        }
    }
    
    func log(command: CDVInvokedUrlCommand) {
        logmsg(command)
        
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    func logException(command: CDVInvokedUrlCommand) {
        logmsg(command)
        Crashlytics.sharedInstance().throwException()
        
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    func crash(command: CDVInvokedUrlCommand) {
        logmsg(command)
        Crashlytics.sharedInstance().crash()
        
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
}
