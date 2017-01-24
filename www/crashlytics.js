var cordova = require("cordova/exec");

var pluginName = "FabricCrashlyticsPlugin";

var names = [
"log",
"setBool",
"setDouble",
"setFloat",
"setInt",
"setUserIdentifier",
"setUserName",
"logException",
"crash"
];

var obj = {};

for (var i = 0; i < names.length; i++) {
    var methodName = names[i];
    obj[methodName] = function() {
        var args = Array.prototype.slice.call(arguments, 0);
        return new Promise(function(resolve, reject) {
            cordova(resolve, reject, pluginName, methodName, args);
        });
    };
}

module.exports = obj;
