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
		},
		eventPurchase: function(map) {
			exec(function() {}, function(error) {}, "eventPurchase", [map]);
		},
		eventAddToCart: function(map) {
			exec(function() {}, function(error) {}, "eventAddToCart", [map]);
		},
		eventStartCheckout: function(map) {
			exec(function() {}, function(error) {}, "eventStartCheckout", [map]);
		},
		eventContentView: function(map) {
			exec(function() {}, function(error) {}, "eventContentView", [map]);
		},
		eventSearch: function(map) {
			exec(function() {}, function(error) {}, "eventSearch", [map]);
		},
		eventShare: function(map) {
			exec(function() {}, function(error) {}, "eventShare", [map]);
		},
		eventRating: function(map) {
			exec(function() {}, function(error) {}, "eventRating", [map]);
		},
		eventSignUp: function(map) {
			exec(function() {}, function(error) {}, "eventSignUp", [map]);
		},
		eventLogin: function(map) {
			exec(function() {}, function(error) {}, "eventLogin", [map]);
		},
		eventInvite: function(map) {
			exec(function() {}, function(error) {}, "eventInvite", [map]);
		},
		eventLevelStart: function(map) {
			exec(function() {}, function(error) {}, "eventLevelStart", [map]);
		},
		eventLevelEnd: function(map) {
			exec(function() {}, function(error) {}, "eventLevelEnd", [map]);
		},
		eventCustom: function(map) {
			exec(function() {}, function(error) {}, "eventCustom", [map]);
		}
}