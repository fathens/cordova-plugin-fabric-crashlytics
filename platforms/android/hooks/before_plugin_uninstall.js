#!/usr/bin/env node

module.exports = function(context) {
  var fs = context.requireCordovaModule('fs');
  var path = context.requireCordovaModule('path');
  var deferral = context.requireCordovaModule('q').defer();

  var main = function() {
    deferral.resolve();
  }
  main();
  return deferral.promise;
};
