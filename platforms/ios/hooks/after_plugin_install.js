#!/usr/bin/env node
var child_process = require('child_process');

var log = function() {
	var args = Array.prototype.map.call(arguments, function(value) {
		if (typeof value === 'string') {
			return value;
		} else {
			return JSON.stringify(value, null, '\t')
		}
	});
	process.stdout.write(args.join(" ") + '\n');
}

module.exports = function(context) {
	var async = context.requireCordovaModule('cordova-lib/node_modules/request/node_modules/form-data/node_modules/async');
	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var deferral = context.requireCordovaModule('q').defer();

	var platformDir = path.join(context.opts.projectRoot, 'platforms', 'ios');

	var podfile = function(next) {
		var target = path.join(platformDir, 'Podfile');
		var lines = ["pod 'Fabric'",
		             "pod 'Crashlytics'"];
		log("Adding ", target, ": ", lines);
		fs.appendFile(target, lines.join('\n'), 'utf-8', next);
	}

	var addInitCode = function(next) {
		var target_name = 'AppDelegate.m';
		var findFiles = function(dir, next) {
			async.waterfall(
					[
					function(next) {
						log("Searching in", dir);
						fs.readdir(dir, next);
					},
					function(list, next) {
						async.map(list, function(item, next) {
							var file = path.resolve(dir, item);
							log("Checking ", file);
							async.waterfall(
									[
									function(next) {
										fs.stat(file, next);
									},
									function(stat, next) {
										if (stat.isDirectory()) {
											findFiles(file, next);
										} else {
											var result = path.basename(file) === target_name ? file : null;
											log("Maching: ", result);
											next(null, result);
										}
									}
									 ],next);
						}, next);
					},
					function(list, next) {
						log("Finder result list: ", list);
						async.filter(list, function(item) {
							return item !== null;
						}, next);
					}
					 ], next);
		}
		var modify = function(target, next) {
			log("Modifying ", file);
			next(null, null);
		}
		async.waterfall(
				[
				function(next) {
					findFiles(platformDir, next);
				},
				function(files, next) {
					log("Found files: ", target_name, files);
					if (files) {
						next(null, files[0]);
					} else {
						next('NotFound: ' + target_name);
					}
				},
				modify,
				 ],next);
	}

	var fixXcodeproj = function(next) {
		var script = path.join(path.dirname(context.scriptLocation), 'after_plugin_install-fix_xcodeproj.rb');
		var child = child_process.execFile(script, [context.opts.plugin.id], {cwd : platformDir}, next);
		child.stdout.on('data', function(data) {
			process.stdout.write(data);
		});
		child.stderr.on('data', function(data) {
			process.stderr.write(data);
		});
	}

	var main = function() {
		async.parallel(
				{
					'Podfile': podfile,
					'Add init code': addInitCode
				},
				function(err, result) {
					if (err) {
						deferral.reject(err);
					} else {
						deferral.resolve(result);
					}
				});
	}
	main();
	return deferral.promise;
};
