'use strict';

var fs = require('fs');
var wiredep = require('wiredep');
var globby = require('globby');

var cwd = '../..';
var root = fs.realpathSync(__dirname + '/' + cwd);
var publicDir = 'lib/puppet-herald/public';
var dependencies = wiredep({
  cwd: publicDir,
  dependencies: true,
  devDependencies: false
}).js.map(function(file) {
  return file.replace(root + '/', '');
});
var devDependencies = wiredep({
  cwd: 'test/javascript',
  dependencies: false,
  devDependencies: true,
  exclude: 'angular/angular.js'
}).js.map(function(file) {
  return file.replace(root + '/', '');
});
var files = {
  html: globby.sync([publicDir+'/**/*.html', '!**/bower_components/**']),
  js: globby.sync([publicDir+'/**/*.js', '!**/bower_components/**']),
  tests: globby.sync(['test/javascript/src/**/*_test.js'])
};
var search = {
  coverage: publicDir + '/!(*bower_components)/**/*.js',
  html2js: publicDir + '/!(*bower_components)/**/*.html'
};
var preprocessors = {};
preprocessors[search.coverage] = ['coverage'];
preprocessors[search.html2js] = ['ng-html2js'];

module.exports = {
  cwd: cwd,
  root: root,
  publicDir: publicDir,
  dependencies: dependencies,
  devDependencies: devDependencies,
  preprocessors: preprocessors,
  files: files
};