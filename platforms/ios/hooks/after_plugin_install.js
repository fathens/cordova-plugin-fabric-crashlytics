#!/usr/bin/env node

var log = function() {
	var args = Array.prototype.map.call(arguments, function(value) {
		if (typeof value === 'string') {
			return value;
		} else {
			return JSON.stringify(value, null, '\t')
		}
	});
	process.stdout.write(args.join('') + '\n');
}

module.exports = function(context) {
	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var glob = context.requireCordovaModule('glob');
	var deferral = context.requireCordovaModule('q').defer();
	var async = context.requireCordovaModule(path.join('request', 'node_modules', 'form-data', 'node_modules', 'async'));
	var xcode = context.requireCordovaModule('xcode');

	var platformDir = path.join(context.opts.projectRoot, 'platforms', 'ios');

	var addInitCode = function(next) {
		var target_name = 'AppDelegate.m';

		var modify = function(target, next) {
			log("Editing ", target);
			
			async.waterfall(
					[
					function(next) {
						fs.readFile(target, 'utf-8', next);
					},
					function(content, next) {
						var cond = {
								did: 0,
								import: 1
						}
						var lines = content.split('\n').map(function(line) {
							var adjustIndent = function(content) {
								var first = line.match(/^[ \t]*/);
								var indent = first.length > 0 ? first[0] : '';
								return indent + content;
							}
							
							var m = [];
							if (line.indexOf('didFinishLaunchingWithOptions') > -1) {
								cond.did = 1;
							}
							if (cond.did === 1 && line.indexOf('return') > -1) {
								m.push(adjustIndent('[Fabric with:@[CrashlyticsKit]];'));
								cond.did = 0;
							}
							if (cond.import === 1 && line.indexOf('#import') > -1) {
								m.push(adjustIndent('#import <Fabric/Fabric.h>'))
								m.push(adjustIndent('#import <Crashlytics/Crashlytics.h>'));
								cond.import = 0;
							}
							m.push(line);
							return m;
						}).reduce(function(a, b) {
							return a.concat(b);
						}, []);
						next(null, lines);
					},
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
		var modify = function(target, next) {
			log("Editing ", target);
			var proj = xcode.project(target);
			async.waterfall(
					[
					function(next) {
						proj.parse(next);
					},
					function(next) {
						var title = 'Fabric';
						var phase = proj.addBuildPhase([], 'PBXShellScriptBuildPhase', title);
						phase.buildPhase.name = title;
						phase.buildPhase.shellPath = '/bin/sh';
						phase.buildPhase.shellScript = ['"./Pods/Fabric/Fabric.framework/run',
						                                process.env.FABRIC_API_KEY,
						                                process.env.FABRIC_BUILD_SECRET].join(' ') + '"';
						var targets = proj.pbxNativeTarget();
						for (var key in targets) {
							var list = targets[key]['buildPhases'];
							if (list) list.push({
								value: phase.uuid,
								comment: title
							});
						}
						fs.writeFile(target, proj.writeSync(), null, next);
					}
					 ], next);
		}
		async.waterfall(
				[
				function(next) {
					glob(path.join(platformDir, '*.xcodeproj', 'project.pbxproj'), null, next);
				},
				function(files, next) {
					if (files.length > 0) {
						next(null, files[0]);
					} else {
						next('NotFound: xcodeproj');
					}
				},
				modify
				 ], next);
	}

	var main = function() {
		async.parallel(
				[
				addInitCode,
				fixXcodeproj
				],
				function(err, result) {
					if (err) {
						log(err);
						deferral.reject(err);
					} else {
						deferral.resolve(result);
					}
				});
	}
	main();
	return deferral.promise;
};
