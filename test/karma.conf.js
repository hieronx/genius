module.exports = function(config){
  config.set({
    preprocessors: {
      //'app/scripts/*.coffee': 'coffee',
      //'app/scripts/**/*.coffee': 'coffee',
      '**/*.coffee': 'coffee'
    },

    basePath : '../',

    files : [
      'app/bower_components/jquery/dist/jquery.js',
      'bower_components/hoodie/dist/hoodie.js',
      'app/bower_components/angular/angular.js',
      'app/bower_components/angular-cookies/angular-cookies.js',
      'app/bower_components/angular-resource/angular-resource.js',
      'app/bower_components/angular-route/angular-route.js',
      'app/bower_components/angular-sanitize/angular-sanitize.js',
      'app/bower_components/angular-mocks/angular-mocks.js',
      'app/bower_components/angular-bootstrap/ui-bootstrap-tpls.js',
      'app/bower_components/underscore/underscore.js',
      'app/scripts/*.coffee',
      'app/scripts/**/*.coffee',
      'app/scripts/**/*.js',
      'test/unit/**/*_spec.coffee'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    plugins : [
      'karma-coffee-preprocessor',
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-jasmine'
    ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }

  });
};
