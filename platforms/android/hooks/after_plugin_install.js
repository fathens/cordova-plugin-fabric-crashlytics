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

	var platformDir = path.join(context.opts.projectRoot, 'platforms', 'android');

	var write_properties = function(next) {
		var file_path = path.join(platformDir, 'fabric.properties');
		var lines = ["apiSecret=" + process.env.FABRIC_BUILD_SECRET, "apiKey=" + process.env.FABRIC_API_KEY]
		log("Writing ", file_path);
		fs.writeFile(file_path, lines.join("\n") + "\n", 'utf-8', next);
	}

	var adjustIndent = function(base, content) {
		var first = base.match(/^[ \t]*/);
		var indent = (first && first.length > 0) ? first[0] : '';
		return indent + content;
	}
	
	var build_gradle = function(next) {
		var target = path.join(platformDir, 'build.gradle');
		log("Editing ", target);
		async.waterfall(
				[
				function(next) {
					fs.readFile(target, 'utf-8', next);
				},
				function(content, next) {
					var cond = {
							compile: 0,
							classpath: 0,
							plugin: 0
					}
					var lines = content.split('\n').map(function (line) {
						var result = [line];
						var adding;
						if (cond.compile === 1) {
							adding = "compile('com.crashlytics.sdk.android:crashlytics:2.5.2@aar') { transitive = true }";
							cond.compile = 0;
						}
						if (cond.classpath === 0) {
							var found = line.match(/classpath 'com\.android\.tools\.build:gradle:1\.[1-9]\.0\+'/);
							if (found && found.length > 0) {
								adding = "classpath 'io.fabric.tools:gradle:1.+'";
								cond.classpath = 1;
							}
						}
						if (cond.plugin === 0 && line.indexOf('apply plugin:') > -1) {
							adding = "apply plugin: 'io.fabric'";
							cond.plugin = 1;
						}
						if (line.indexOf('mavenCentral') > -1) {
							adding = "maven { url 'https://maven.fabric.io/public' }";
						}
						if (line.indexOf('dependencies') === 0) {
							cond.compile = 1;
						}
						if (adding) result.push(adjustIndent(line, adding));
						return result;
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
	
	var main_activity = function(next) {
		var target_name = 'MainActivity.java';
		
		var modify = function(target, next) {
			log("Editing ", target);
			async.waterfall(
					[
					function(next) {
						fs.readFile(target, 'utf-8', next);
					},
					function(content, next) {
						var lines = content.split('\n').map(function (line) {
							var result = [line];
							if (line.indexOf('super.onCreate') > -1) {
								var content = 'io.fabric.sdk.android.Fabric.with(this, new com.crashlytics.android.Crashlytics());';
								result.push(adjustIndent(line, content));
							}
							return result;
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
					glob(path.join(platformDir, 'src', '**', target_name), null, next);
				},
				function(files, next) {
					if (files && files.length > 0) {
						next(null, files[0]);
					} else {
						next('NotFound: ' + target_name);
					}
				},
				modify
				 ], next);
	}

	var main = function() {
		async.parallel(
				[
				write_properties,
				build_gradle,
				main_activity
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
