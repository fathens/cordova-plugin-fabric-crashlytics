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
    }
}
