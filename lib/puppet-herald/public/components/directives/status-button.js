(function() {

  'use strict';

  var module = angular.module('herald.directives.status-button', [

  ]);

  module.controller('StatusButtonController', ['$location', '$scope', function($location, $scope) {

    $scope.$location = $location;

    $scope.navigate = function() {
      var target = this.route.replace(':id', this.id);
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