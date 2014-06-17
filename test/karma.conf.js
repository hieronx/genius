module.exports = function(config){
  config.set({
    preprocessors: {
      '**/*.coffee': 'coffee'
    },

    basePath : '../',

    files : [
      'app/bower_components/jquery/dist/jquery.js',
      'app/bower_components/hoodie/dist/hoodie.js',
      'app/bower_components/angular/angular.js',
      'app/bower_components/angular-cookies/angular-cookies.js',
      'app/bower_components/angular-resource/angular-resource.js',
      'app/bower_components/angular-route/angular-route.js',
      'app/bower_components/angular-sanitize/angular-sanitize.js',
      'app/bower_components/angular-mocks/angular-mocks.js',
      'app/bower_components/angular-bootstrap/ui-bootstrap-tpls.js',
      'app/bower_components/underscore/underscore.js',
      'app/bower_components/highcharts-ng/dist/highcharts-ng.js',
      'app/scripts/*.coffee',
      'app/scripts/models/active_record/callbacks.coffee',
      'app/scripts/models/active_record/collections.coffee',
      'app/scripts/models/active_record/attributes.coffee',
      'app/scripts/models/active_record/associations.coffee',
      'app/scripts/models/active_record/base.coffee',
      'app/scripts/**/*.coffee',
      'app/scripts/**/*.js',
      'test/unit/**/*Spec.coffee'
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
