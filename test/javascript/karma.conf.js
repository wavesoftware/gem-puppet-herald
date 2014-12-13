module.exports = function(config) {
  config.set({
    frameworks: ['jasmine'],

    files: [
      '../../node_modules/angular/angular.js',
      '../../node_modules/angular-loader/angular-loader.js',
      '../../node_modules/angular-mocks/angular-mocks.js',
      '../../node_modules/angular-route/angular-route.js',
      '../../lib/puppet-herald/public/**/*_test.js'
    ]
  });
};