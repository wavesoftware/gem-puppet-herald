'use strict';

angular.module('herald.nodes', [
  'ngRoute',
  'herald.directives',
  'herald.page',
  'angularMoment'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/nodes', {
    templateUrl: 'nodes/nodes.html',
    controller: 'NodesController'
  });
}])

.controller('NodesController', ['$http', 'Page', function($http, Page) {
  Page.title('All nodes');
  var ctrl = this;
  ctrl.all = [];

  $http.get('/api/v1/nodes').success(function(data) {
    ctrl.all = data;
  });
}]);