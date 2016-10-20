import Foundation
import Cordova
import Fabric
import Crashlytics

extension Dictionary {
    func getString(_ key: Key) -> String? {
        return self[key] as? String
    }
    
    func getDouble(_ key: Key) -> Double? {
        return self[key].flatMap { $0 as AnyObject }.flatMap { $0.doubleValue }
    }
    
    func getDecimal(_ key: Key) -> NSDecimalNumber? {
        return getDouble(key).map { NSDecimalNumber(value: $0 as Double) }
    }
    
    func getBool(_ key: Key) -> Int? {
        return self[key].flatMap { $0 as? Bool }.map { $0 ? 1 : 0 }
    }
}

@objc(FabricAnswers)
class FabricAnswers: CDVPlugin {
    fileprivate func frame(_ command: CDVInvokedUrlCommand, _ proc: (Dictionary<String, AnyObject>?, Dictionary<String, AnyObject>?) -> Void) {
        let dict = command.arguments.first.flatMap { $0 as? Dictionary<String, AnyObject> }
        let custom = dict?["custom"] as? Dictionary<String, AnyObject>
        
        proc(dict, custom)
        commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    func eventPurchase(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = dict?.getDecimal("itemPrice")
            let currency = dict?.getString("currency")
            let success = dict?.getBool("success")
            let name = dict?.getString("itemName")
            let type = dict?.getString("itemType")
            let id = dict?.getString("itemId")
            Answers.logPurchase(withPrice: price, currency: currency, success: success as NSNumber?, itemName: name, itemType: type, itemId: id, customAttributes: custom)
        }
    }
    
    func eventAddToCart(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = dict?.getDecimal("itemPrice")
            let currency = dict?.getString("currency")
            let name = dict?.getString("itemName")
            let type = dict?.getString("itemType")
            let id = dict?.getString("itemId")
            Answers.logAddToCart(withPrice: price, currency: currency, itemName: name, itemType: type, itemId: id, customAttributes: custom)
        }
    }
    
    func eventStartCheckout(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let price = dict?.getDecimal("totalPrice")
            let currency = dict?.getString("currency")
            let count = dict?.getDouble("itemCount")
            Answers.logStartCheckout(withPrice: price, currency: currency, itemCount: count as NSNumber?, customAttributes: custom)
        }
    }
    
    func eventContentView(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("contentName")
            let type = dict?.getString("contentType")
            let id = dict?.getString("contentId")
            Answers.logContentView(withName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventSearch(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let query = dict?.getString("query")
            Answers.logSearch(withQuery: query, customAttributes: custom)
        }
    }
    
    func eventShare(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            let name = dict?.getString("contentName")
            let type = dict?.getString("contentType")
            let id = dict?.getString("contentId")
            Answers.logShare(withMethod: method, contentName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventRating(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let rating = dict?.getDouble("rating")
            let name = dict?.getString("contentName")
            let type = dict?.getString("contentType")
            let id = dict?.getString("contentId")
            Answers.logRating(rating as NSNumber?, contentName: name, contentType: type, contentId: id, customAttributes: custom)
        }
    }
    
    func eventSignUp(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            let success = dict?.getBool("success")
            Answers.logSignUp(withMethod: method, success: success as NSNumber?, customAttributes: custom)
        }
    }
    
    func eventLogin(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            let success = dict?.getBool("success")
            Answers.logLogin(withMethod: method, success: success as NSNumber?, customAttributes: custom)
        }
    }
    
    func eventInvite(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let method = dict?.getString("method")
            Answers.logInvite(withMethod: method, customAttributes: custom)
        }
    }
    
    func eventLevelStart(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("levelName")
            Answers.logLevelStart(name, customAttributes: custom)
        }
    }
    
    func eventLevelEnd(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("levelName")
            let score = dict?.getDouble("score")
            let success = dict?.getBool("success")
            Answers.logLevelEnd(name, score: score as NSNumber?, success: success as NSNumber?, customAttributes: custom)
        }
    }
    
    func eventCustom(_ command: CDVInvokedUrlCommand) {
        frame(command) { dict, custom in
            let name = dict?.getString("name")
            let attrs = dict?["attributes"] as? Dictionary<String, AnyObject>
            Answers.logCustomEvent(withName: name == nil ? "NoName": name!, customAttributes: attrs)
        }
    }
}
