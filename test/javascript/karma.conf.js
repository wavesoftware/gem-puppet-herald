var project = require('../../lib/puppet-herald/project');

var files = project.dependencies.
    concat(project.devDependencies).
    concat(project.files.js).
    concat(project.files.html).
    concat(project.files.tests);

module.exports = function(config) {
  config.set({

    basePath: project.cwd,

    singleRun: true,

    frameworks: ['jasmine'],

    reporters: ['story', 'coverage'],

    // source files, that you wanna generate coverage for
    // do not include tests or libraries
    // (these files will be instrumented by Istanbul)
    preprocessors: project.preprocessors,

    // optionally, configure the reporter
    coverageReporter: {
      dir : 'coverage/javascript',
      reporters: [
        // reporters not supporting the `file` property
        { type: 'lcov', subdir: 'lcov' },
        // reporters supporting the `file` property, use `subdir` to directly
        // output them in the `dir` directory
        { type: 'cobertura', subdir: '.', file: 'cobertura.xml' },
        { type: 'text', subdir: '.', file: 'text.txt' },
        { type: 'text-summary', subdir: '.', file: 'text-summary.txt' },
      ]
    },

    ngHtml2JsPreprocessor: {
      // strip this from the file path
      stripPrefix: project.publicDir + '/',
    },

    files: files
  });
};