require('coffee-script');
require('../app/scripts/vendor/hoodie.js');

exports.config = {
  allScriptsTimeout: 11000,

  specs: [
    'e2e/**/*_spec.coffee'
  ],

  capabilities: {
    'browserName': 'chrome'
  },

  chromeOnly: true,

  baseUrl: 'http://127.0.0.1:9000/',

  framework: 'jasmine',

  jasmineNodeOpts: {
    defaultTimeoutInterval: 30000
  },
  
  onPrepare: function() {
    global.findBy = protractor.By;
  }
};
