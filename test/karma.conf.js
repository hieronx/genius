module.exports = function(config){
  config.set({


    basePath : '../',

    files : [
      'app/bower_components/angular/angular.js',
      'app/bower_components/angular-route/angular-route.js',
      'app/bower_components/angular-resource/angular-resource.js'
      'app/bower_components/angular-mocks/angular-mocks.js',
      //'app/scripts/**/*.coffee',
      //'test/unit/**/*_spec.coffee',

      {
        pattern: 'test/unit/**/*_spec.coffee',
        included: true
      }
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    plugins : [
      //'karma-coffee-preprocessor',
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
