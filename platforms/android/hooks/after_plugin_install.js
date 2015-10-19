#!/usr/bin/env node
var child_process = require('child_process');

module.exports = function(context) {
	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var deferral = context.requireCordovaModule('q').defer();

	var make_platform_dir = function(base) {
		return path.join(base, 'platforms', 'android');
	}
	var platformDir = make_platform_dir(context.opts.projectRoot)
	var pluginDir = path.join(context.opts.projectRoot, 'plugins', context.opts.plugin.id);

	var write_properties = function() {
		var file_path = path.join(platformDir, 'fabric.properties');
		var lines = [ "apiSecret=" + process.env.FABRIC_BUILD_SECRET, "apiKey=" + process.env.FABRIC_API_KEY,
				"betaDistributionReleaseNotesFilePath=" + process.env.RELEASE_NOTE_PATH,
				"betaDistributionGroupAliases=" + process.env.CRASHLYTICS_GROUPS, "" ]
		fs.writeFileSync(file_path, lines.join("\n"));
	}

	var main = function() {
		process.stdout.write("################################ Start preparing\n")
		write_properties();

		var script = path.join(make_platform_dir(pluginDir), 'hooks', 'after_plugin_install.sh');
		process.stdout.write("Running " + script);
		var child = child_process.execFile(script, [], {
			cwd : platformDir
		}, function(error) {
			if (error) {
				deferral.reject(error);
			} else {
				process.stdout.write("################################ Finish preparing\n\n")
				deferral.resolve();
			}
		});
		child.stdout.on('data', function(data) {
			process.stdout.write(data);
		});
		child.stderr.on('data', function(data) {
			process.stderr.write(data);
		});
	}
	main();
	return deferral.promise;
};
