'use strict';

angular.module('herald.node', [
  'ngRoute',
  'herald.directives'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/node/:nodeId', {
    templateUrl: 'node/node.html',
    controller: 'NodeController'
  });
}])

.controller('NodeController', ['$http', '$routeParams', function($http, $routeParams) {
  var ctrl = this;
  ctrl.node = null;

  this.nodeId = $routeParams.nodeId;

  $http.get('/api/v1/node/' + this.nodeId).success(function(data) {
    ctrl.node = data;
  });
}]);