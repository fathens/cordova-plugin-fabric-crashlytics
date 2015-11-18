import Foundation
import Cordova
import Fabric
import Crashlytics

extension Dictionary {
    func getString(key: Key) -> String? {
        return self[key] as? String
    }
    
    func getDouble(key: Key) -> Double? {
        return self[key].flatMap { $0 as? AnyObject }.flatMap { $0.doubleValue }
    }
    
    func getDecimal(key: Key) -> NSDecimalNumber? {
        return getDouble(key).map { NSDecimalNumber(double: $0) }
    }
    
    func getBool(key: Key) -> Int? {
        return self[key].flatMap { $0 as? Bool }.map { $0 ? 1 : 0 }
    }
}

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
            let price = dict?.getDecimal("itemPrice")
            let currency = dict?.getString("currency")
            let success = dict?.getBool("success")
            let name = dict?.getString("itemName")
            let type = dict?.getString("itemType")
            let id = dict?.getString("itemId")
            Answers.logPurchaseWithPrice(price, currency: currency, success: success, itemName: name, itemType: type, itemId: id, customAttributes: custom)
        }
    }
    
    func eventAddToCart(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = dict?.getDecimal("itemPrice")
            let currency = dict?.getString("currency")
            let name = dict?.getString("itemName")
            let type = dict?.getString("itemType")
            let id = dict?.getString("itemId")
            Answers.logAddToCartWithPrice(price, currency: currency, itemName: name, itemType: type, itemId: id, customAttributes: custom)
        }
    }
    
    func eventStartCheckout(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = dict?.getDecimal("totalPrice")
            let currency = dict?.getString("currency")
            let count = dict?.getDouble("itemCount")
            Answers.logStartCheckoutWithPrice(price, currency: currency, itemCount: count, customAttributes: custom)
        }
    }
    
    func eventContentView(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("contentName")
            let type = dict?.getString("contentType")
            let id = dict?.getString("contentId")
            Answers.logContentViewWithName(name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventSearch(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let query = dict?.getString("query")
            Answers.logSearchWithQuery(query, customAttributes: custom)
        }
    }
    
    func eventShare(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            let name = dict?.getString("contentName")
            let type = dict?.getString("contentType")
            let id = dict?.getString("contentId")
            Answers.logShareWithMethod(method, contentName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventRating(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let rating = dict?.getDouble("rating")
            let name = dict?.getString("contentName")
            let type = dict?.getString("contentType")
            let id = dict?.getString("contentId")
            Answers.logRating(rating, contentName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventSignUp(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            let success = dict?.getBool("success")
            Answers.logSignUpWithMethod(method, success: success, customAttributes: custom)
        }
    }
    
    func eventLogin(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            let success = dict?.getBool("success")
            Answers.logLoginWithMethod(method, success: success, customAttributes: custom)
        }
    }
    
    func eventInvite(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            Answers.logInviteWithMethod(method, customAttributes: custom)
        }
    }
    
    func eventLevelStart(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("levelName")
            Answers.logLevelStart(name, customAttributes: custom)
        }
    }
    
    func eventLevelEnd(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("levelName")
            let score = dict?.getDouble("score")
            let success = dict?.getBool("success")
            Answers.logLevelEnd(name, score: score, success: success, customAttributes: custom)
        }
    }
    
    func eventCustom(command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("name")
            let attrs = dict?["attributes"] as? Dictionary<String, AnyObject>
            Answers.logCustomEventWithName(name == nil ? "NoName": name!, customAttributes: attrs)
        }
    }
}
