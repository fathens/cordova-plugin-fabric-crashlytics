var exec = require("cordova/exec");

module.exports = {
		log: function(msg) {
			exec(function() {}, function(error) {}, "log", [msg]);
		},
		setBool: function(key, value) {
			exec(function() {}, function(error) {}, "setBool", [key, value]);
		},
		setDouble: function(key, value) {
			exec(function() {}, function(error) {}, "setDouble", [key, value]);
		},
		setFloat: function(key, value) {
			exec(function() {}, function(error) {}, "setFloat", [key, value]);
		},
		setInt: function(key, value) {
			exec(function() {}, function(error) {}, "setInt", [key, value]);
		},
		setUserIdentifier: function(identifier) {
			exec(function() {}, function(error) {}, "setUserIdentifier", [identifier]);
		},
		setUserName: function(name) {
			exec(function() {}, function(error) {}, "setUserName", [name]);
		},
		logException: function(message) {
			exec(function() {}, function(error) {}, "logException", [message]);
		},
		crash: function(message) {
			exec(function() {}, function(error) {}, "crash", [message]);
		}
}