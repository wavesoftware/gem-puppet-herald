(function() {

  'use strict';

  var module = angular.module('herald.directives.status-button', [

  ]);

  module.directive('statusLabel', function() {
    return {
      restrict: 'A',
      templateUrl: 'components/directives/status-button.html',
      controller: function($scope) {

      }
    };
  });

  module.filter('colorizeStatus', function() {
    return function(input) {
      switch(input) {
        case 'unchanged': return 'success';
        case 'changed':   return 'info';
        case 'failed':    return 'danger';
        default:          return 'default';
      }
    }
  });

  module.filter('iconizeStatus', function() {
    return function(input) {
      switch(input) {
        case 'unchanged': return 'ok';
        case 'changed':   return 'pencil';
        case 'failed':    return 'remove';
        default:          return 'asterisk';
      }
    }
  });
})();