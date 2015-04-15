(function() {

  'use strict';

  var module = angular.module('herald.directives.status-button', [ 'ui.router' ]);

  module.controller('StatusButtonController', ['$state', '$scope', function($state, $scope) {

    $scope.$state = $state;

    $scope.navigate = function(route, idName, id) {
      var params = {};
      params[idName] = id;
      this.$state.go(route, params);
    };

  }]);

  module.directive('wsStatusButton', function() {
    return {
      restrict: 'E',
      scope: {
        status: '=',
        id: '=',
        idname: '=',
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