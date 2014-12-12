'use strict';

angular.module('herald.nodes', [
  'ngRoute',
  'herald.directives',
  'angularMoment'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/nodes', {
    templateUrl: 'nodes/nodes.html',
    controller: 'NodesController'
  });
}])

.controller('NodesController', ['$http', 'appService', function($http, appService) {
  appService.page = 'nodes';
  var ctrl = this;
  ctrl.all = [];

  $http.get('/api/v1/nodes').success(function(data) {
    ctrl.all = data;
  });
}]);