import Foundation

@objc(FabricAnswers)
class FabricAnswers: CDVPlugin {
    private func frame(command: CDVInvokedUrlCommand, _ proc: (Dictionary<String, AnyObject>?, Dictionary<String, AnyObject>?) -> Void) {
        let dict = command.arguments.first.flatMap { $0 as? Dictionary<String, AnyObject> }
        let custom = dict?["custom"] as? Dictionary<String, AnyObject>
        
        proc(dict, custom)
        commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    func eventPurchase(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = dict?["itemPrice"].map { NSDecimalNumber(string: $0.string) }
            let currency = dict?["currency"] as? String
            let success = (dict?["success"] as? Bool).map { $0 ? 1 : 0 }
            let name = dict?["itemName"] as? String
            let type = dict?["itemType"] as? String
            let id = dict?["itemId"] as? String
            Answers.logPurchaseWithPrice(price, currency: currency, success: success, itemName: name, itemType: type, itemId: id, customAttributes: custom)
        }
    }
    
    func eventAddToCart(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = (dict?["itemPrice"] as? NSNumber).map { NSDecimalNumber(decimal: $0.decimalValue) }
            let currency = dict?["currency"] as? String
            let name = dict?["itemName"] as? String
            let type = dict?["itemType"] as? String
            let id = dict?["itemId"] as? String
            Answers.logAddToCartWithPrice(price, currency: currency, itemName: name, itemType: type, itemId: id, customAttributes: custom)
        }
    }
    
    func eventStartCheckout(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = (dict?["totalPrice"] as? NSNumber).map { NSDecimalNumber(decimal: $0.decimalValue) }
            let currency = dict?["currency"] as? String
            let count = dict?["itemCount"] as? NSNumber
            Answers.logStartCheckoutWithPrice(price, currency: currency, itemCount: count, customAttributes: custom)
        }
    }
    
    func eventContentView(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?["contentName"] as? String
            let type = dict?["contentType"] as? String
            let id = dict?["contentId"] as? String
            Answers.logContentViewWithName(name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventSearch(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let query = dict?["query"] as? String
            Answers.logSearchWithQuery(query, customAttributes: custom)
        }
    }
    
    func eventShare(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?["method"] as? String
            let name = dict?["contentName"] as? String
            let type = dict?["contentType"] as? String
            let id = dict?["contentId"] as? String
            Answers.logShareWithMethod(method, contentName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventRating(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let rating = dict?["rating"] as? NSNumber
            let name = dict?["contentName"] as? String
            let type = dict?["contentType"] as? String
            let id = dict?["contentId"] as? String
            Answers.logRating(rating, contentName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventSignUp(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?["method"] as? String
            let success = (dict?["success"] as? Bool).map { $0 ? 1 : 0 }
            Answers.logSignUpWithMethod(method, success: success, customAttributes: custom)
        }
    }
    
    func eventLogin(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?["method"] as? String
            let success = (dict?["success"] as? Bool).map { $0 ? 1 : 0 }
            Answers.logLoginWithMethod(method, success: success, customAttributes: custom)
        }
    }
    
    func eventInvite(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?["method"] as? String
            Answers.logInviteWithMethod(method, customAttributes: custom)
        }
    }
    
    func eventLevelStart(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?["levelName"] as? String
            Answers.logLevelStart(name, customAttributes: custom)
        }
    }
    
    func eventLevelEnd(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?["levelName"] as? String
            let score = dict?["score"] as? NSNumber
            let success = (dict?["success"] as? Bool).map { $0 ? 1 : 0 }
            Answers.logLevelEnd(name, score: score, success: success, customAttributes: custom)
        }
    }
    
    func eventCustom(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?["name"] as? String
            let attrs = dict?["attributes"] as? Dictionary<String, AnyObject>
            Answers.logCustomEventWithName(name == nil ? "NoName": name!, customAttributes: attrs)
        }
    }
}
