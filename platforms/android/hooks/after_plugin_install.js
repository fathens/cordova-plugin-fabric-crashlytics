#!/usr/bin/env node
var child_process = require('child_process');

module.exports = function(context) {
	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var deferral = context.requireCordovaModule('q').defer();
	var androidPlatformDir = path.join(context.opts.projectRoot, 'platforms', 'android');
	
	var shell_command = function() {
		var cmd = path.join(context.opts.projectRoot, 'plugins', 'org.fathens.cordova.plugin.fabric.Crashlytics', 'platforms', 'android', 'hooks', 'after_plugin_install.sh');
		var args = [ androidPlatformDir ];
		var child = child_process.spawn(cmd, args);
	}
	
	var write_properties = function() {
		process.stdout.write(JSON.stringify(process.env, null, '\t'));
		var file_path = path.join(androidPlatformDir, 'fabric.properties');
		var lines = ["apiSecret=" + process.env.FABRIC_BUILD_SECRET,
		             "apiKey=" + process.env.FABRIC_API_KEY,
		             "betaDistributionReleaseNotesFilePath=" + process.env.RELEASE_NOTE_PATH,
		             "betaDistributionGroupAliases=" + process.env.CRASHLYTICS_GROUPS,
		             ""]
		fs.writeFileSync(file_path, lines.join("\n"));
	}

	var main = function() {
		shell_command();
		write_properties();
		
		deferral.resolve();
	}
	main();
	return deferral.promise;
};
