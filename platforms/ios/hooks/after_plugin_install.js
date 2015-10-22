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
	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var glob = context.requireCordovaModule('glob');
	var deferral = context.requireCordovaModule('q').defer();
	var async = context.requireCordovaModule(path.join('request', 'node_modules', 'form-data', 'node_modules', 'async'));

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

		var reducer = function(list, next) {
			async.reduce(list, [], function(a, item, next) {
				next(null, a.concat(item));
			}, next);
		}

		var modify = function(target, next) {
			log("Editing ", target);
			
			async.waterfall(
					[
					function(next) {
						fs.readFile(target, 'utf-8', next);
					},
					function(content, next) {
						var lines = content.split('\n');
						var cond = {
								did: 0,
								import: 1
						}
						async.map(lines, function(line, next) {
							var adjustIndent = function(content) {
								var first = line.match(/^[ \t]*/);
								var indent = first.length > 0 ? first[0] : '';
								return indent + content;
							}
							
							var m = [];
							var addInitCall = function() {
								if (line.indexOf('didFinishLaunchingWithOptions') > -1) {
									cond.did = 1;
								}
								if (cond.did === 1 && line.indexOf('return') > -1) {
									m.push(adjustIndent('[Fabric with:@[CrashlyticsKit]];'));
									cond.did = 0;
								}
							}
							var addImport = function() {
								if (cond.import === 1 && line.indexOf('#import') > -1) {
									m.push(adjustIndent('#import <Fabric/Fabric.h>'))
									m.push(adjustIndent('#import <Crashlytics/Crashlytics.h>'));
									cond.import = 0;
								}
							}
							addInitCall();
							addImport();
							m.push(line);
							next(null, m);
						}, next);
					},
					reducer,
					function(lines, next) {
						fs.writeFile(target, lines.join('\n'), 'utf-8', next);
					}
					 ], next);
		}
		async.waterfall(
				[
				function(next) {
					glob(path.join(platformDir, '**', target_name), null, next);
				},
				function(files, next) {
					if (files.length > 0) {
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
					'Add init code': addInitCode,
					'Fix Xcodeproj': fixXcodeproj
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
