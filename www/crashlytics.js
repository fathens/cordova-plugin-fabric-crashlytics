var exec = require("cordova/exec");

var pluginName = "FabricCrashlyticsPlugin";

var names = [
"log",
"setBool",
"setDouble",
"setFloat",
"setInt",
"setUserEmail",
"setUserIdentifier",
"setUserName",
"logException",
"crash"
];

var obj = {};

names.forEach(function(methodName) {
    obj[methodName] = function() {
        var args = Array.prototype.slice.call(arguments, 0);
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, pluginName, methodName, args);
        });
    };
});

module.exports = obj;
