var exec = require("cordova/exec");

module.exports = {
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