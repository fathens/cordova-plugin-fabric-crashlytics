var cordova = require("cordova/exec");

function exec(name, map) {
	cordova(function() {}, function(error) {
		alert("Error on " + name + "\n" + error);
	}, "FabricAnswersPlugin", name, [map]);
}

var names = [
"eventPurchase",
"eventAddToCart",
"eventStartCheckout",
"eventContentView",
"eventSearch",
"eventShare",
"eventRating",
"eventSignUp",
"eventLogin",
"eventInvite",
"eventLevelStart",
"eventLevelEnd",
"eventCustom"
];

var obj = {};

names.forEach(function(name) {
	obj[name] = function(map) { exec(name, map) }
});

module.exports = obj;

