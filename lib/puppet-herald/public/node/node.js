'use strict';

angular.module('herald.node', [
  'ngRoute',
  'herald.page',
  'herald.directives',
  'angularMoment'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/node/:nodeId', {
    templateUrl: 'node/node.html',
    controller: 'NodeController'
  });
}])

.controller('NodeController', ['$http', '$routeParams', 'Page', function($http, $routeParams, Page) {
  var ctrl = this;
  ctrl.node = null;
  Page.title('Node');
  this.nodeId = $routeParams.nodeId;

  $http.get('/api/v1/node/' + this.nodeId).success(function(data) {
    ctrl.node = data;
    Page.title('Node', data.name);
  });
}]);