import Foundation

@objc(FabricAnswers)
class FabricAnswers: CDVPlugin {
    func eventLogin(command: CDVInvokedUrlCommand) {
        func event() -> (String?, NSNumber?, [String: AnyObject]?) {
            if let v = command.arguments.first {
                if (v is NSDictionary) {
                    let method = v.stringForKey("method")
                    let success = v.boolForKey("success") ? 1 : 0
                    let custom = v.dictionaryForKey("custom")
                    return (method, success, custom)
                }
            }
            return (nil, nil, nil)
        }
        let (method, success, attrs) = event()
        Answers.logLoginWithMethod(method, success: success, customAttributes: attrs)
        
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
}
