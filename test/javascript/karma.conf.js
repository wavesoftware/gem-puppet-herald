module.exports = function(config) {
  config.set({

    basePath: '../..',

    singleRun: true,

    frameworks: ['jasmine'],

    reporters: ['story', 'coverage'],

    preprocessors: {
      // source files, that you wanna generate coverage for
      // do not include tests or libraries
      // (these files will be instrumented by Istanbul)
      'lib/puppet-herald/public/**/*.js': ['coverage'],
      'lib/puppet-herald/public/**/*.html': ['ng-html2js']
    },

    // optionally, configure the reporter
    coverageReporter: {
      dir : 'coverage/javascript',
      reporters: [
        // reporters not supporting the `file` property
        { type: 'html', subdir: 'report-html' },
        // reporters supporting the `file` property, use `subdir` to directly
        // output them in the `dir` directory
        { type: 'cobertura', subdir: '.', file: 'cobertura.txt' },
        { type: 'text', subdir: '.', file: 'text.txt' },
        { type: 'text-summary', subdir: '.', file: 'text-summary.txt' },
      ]
    },

    ngHtml2JsPreprocessor: {
      // strip this from the file path
      stripPrefix: 'lib/puppet-herald/public/',
    },

    files: [
      'node_modules/angular/angular.js',
      'node_modules/angular-loader/angular-loader.js',
      'node_modules/angular-mocks/angular-mocks.js',
      'node_modules/angular-route/angular-route.js',
      'node_modules/moment/moment.js',
      'node_modules/angular-moment/angular-moment.js',
      'lib/puppet-herald/public/**/*.js',
      'lib/puppet-herald/public/**/*.html',
      'test/javascript/src/**/*.js'
    ]
  });
};