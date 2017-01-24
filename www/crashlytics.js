var cordova = require("cordova/exec");

var pluginName = "FabricCrashlyticsPlugin";

var obj = {};

[
"log",
"setBool",
"setDouble",
"setFloat",
"setInt",
"setUserIdentifier",
"setUserName",
"logException",
"crash"
].forEach((methodName) => {
    obj[methodName] = function() {
        var resolve = arguments[0];
        var reject = arguments[1];
        var args = Array.prototype.slice.call(arguments, 2);
        console.log("Calling cordova plugin: " + pluginName + "." + methodName);
        return cordova(resolve, reject, pluginName, methodName, args);
    };
});

module.exports = obj;
