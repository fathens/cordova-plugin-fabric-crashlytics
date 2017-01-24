var cordova = require("cordova/exec");

var pluginName = "FabricCrashlyticsPlugin";

var obj = {};

function add_fun(methodName) {
    obj[methodName] = function() {
        var args = Array.prototype.slice.call(arguments, 0);
        return new Promise(function(resolve, reject) {
            cordova(resolve, reject, pluginName, methodName, args);
        });
    }
}

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

for (var i = 0; i < names.length; i++) {
    add_fun(names[i]);
}

module.exports = obj;
