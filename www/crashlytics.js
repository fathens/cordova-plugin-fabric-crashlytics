var cordova = require("cordova/exec");

function exec(name, args) {
	cordova(function() {}, function(error) {
		alert("Error on " + name + "\n" + error);
	}, "FabricCrashlyticsPlugin", name, args);
}

module.exports = {
		log: function(msg) {
			exec("log", [msg]);
		},
		setBool: function(key, value) {
			exec("setBool", [key, value]);
		},
		setDouble: function(key, value) {
			exec("setDouble", [key, value]);
		},
		setFloat: function(key, value) {
			exec("setFloat", [key, value]);
		},
		setInt: function(key, value) {
			exec("setInt", [key, value]);
		},
		setUserIdentifier: function(identifier) {
			exec("setUserIdentifier", [identifier]);
		},
		setUserName: function(name) {
			exec("setUserName", [name]);
		},
		logException: function(message) {
			exec("logException", [message]);
		},
		crash: function(message) {
			exec("crash", [message]);
		}
}
