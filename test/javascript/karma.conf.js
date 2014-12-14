module.exports = function(config) {
  config.set({

    singleRun: true,

    frameworks: ['jasmine'],

    reporters: ['story', 'coverage'],

    preprocessors: {
      // source files, that you wanna generate coverage for
      // do not include tests or libraries
      // (these files will be instrumented by Istanbul)
      '../../lib/puppet-herald/public/**/*.js': ['coverage']
    },

    // optionally, configure the reporter
    coverageReporter: {
      dir : '../../coverage/javascript',
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

    files: [
      '../../node_modules/angular/angular.js',
      '../../node_modules/angular-loader/angular-loader.js',
      '../../node_modules/angular-mocks/angular-mocks.js',
      '../../node_modules/angular-route/angular-route.js',
      '../../lib/puppet-herald/public/**/*.js',
      'src/**/*.js'
    ]
  });
};