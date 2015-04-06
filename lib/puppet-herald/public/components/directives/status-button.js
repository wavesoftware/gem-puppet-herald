(function() {

  'use strict';

  var module = angular.module('herald.directives.status-button', [

  ]);

  module.controller('StatusButtonController', ['$location', '$scope', function($location, $scope) {

    $scope.$location = $location;

    $scope.navigate = function(route, id) {
      var target = route.replace(':id', id);
      this.$location.path(target);
    };

  }]);

  module.directive('ngStatusButton', function() {
    return {
      restrict: 'E',
      scope: {
        status: '=',
        id: '=',
        route: '='
      },
      controller: 'StatusButtonController',
      templateUrl: 'components/directives/status-button.html'
    };
  });

  module.filter('colorizeStatus', function() {
    return function(input) {
      switch(input) {
        case 'unchanged': return 'success';
        case 'changed':   return 'info';
        case 'failed':    return 'danger';
        case 'pending':   return 'warning';
        default:          return 'default';
      }
    };
  });

  module.filter('iconizeStatus', function() {
    return function(input) {
      switch(input) {
        case 'unchanged': return 'ok';
        case 'changed':   return 'pencil';
        case 'failed':    return 'remove';
        case 'pending':   return 'asterisk';
        default:          return 'sign';
      }
    };
  });
})();