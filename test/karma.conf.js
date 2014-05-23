module.exports = function(config){
  config.set({
    preprocessors: {
      'app/scripts/*.coffee': 'coffee',
      'app/scripts/**/*.coffee': 'coffee',
      'test/unit/**/*.coffee': 'coffee'
    },

    basePath : '../',

    files : [
      'app/bower_components/jquery/dist/jquery.min.js',
      'app/bower_components/angular/angular.js',
      'app/bower_components/angular-route/angular-route.js',
      'app/bower_components/angular-resource/angular-resource.js',
      'app/bower_components/angular-mocks/angular-mocks.js',
      'app/scripts/*.coffee',
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
