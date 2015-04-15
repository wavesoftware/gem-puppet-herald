(function(angular){
  'use strict';

  var module = angular.module('herald.settings' , ['ngStorage']);

  module.factory('Settings', ['$localStorage', function($localStorage) {
    var settings = {
      colorSyntax: {
        options: [
          { label: 'Puppet 2.x', value: 'puppet2' },
          { label: 'Puppet 3.x', value: 'puppet3' }
        ]
      },
      report: {
        info: true
      },
      pagination: {
        perPage: 15
      }
    };
    settings.colorSyntax.selected = settings.colorSyntax.options[0];
    return $localStorage.$default(settings);
  }]);

})(angular);