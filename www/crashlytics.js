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
].forEach(function(methodName) {
    obj[methodName] = function() {
        var args = Array.prototype.slice.call(arguments, 0);
        return new Promise(function(resolve, reject) {
            cordova(resolve, reject, pluginName, methodName, args);
        });
    }
});

module.exports = obj;
