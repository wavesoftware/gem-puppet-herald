(function() {

'use strict';

angular.module('herald.node', [
  'ngRoute',
  'herald.page',
  'herald.directives',
  'herald.pagination',
  'angularMoment'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/node/:nodeId', {
    templateUrl: 'node/node.html',
    controller: 'NodeController'
  });
}])

.controller('NodeController', 
    ['$http', '$location', '$routeParams', 'Page', 'PaginationFactory', 
        function($http, $location, $routeParams, Page, PaginationFactory) {

  var ctrl = this;
  ctrl.pagination = PaginationFactory.DEFAULT;
  ctrl.node = null;
  Page.title('Node');
  this.nodeId = $routeParams.nodeId;
  var gateway = '/api/v1/nodes/' + this.nodeId;
  var headers = this.pagination.toHeaders();
  var config = { headers: headers };
  var listener = function(page) {
    $location.path('/node/' + ctrl.nodeId + '?page=' + page);
  };

  $http.get(gateway, config).success(function(data, status, headers, config) {
    ctrl.node = data;
    ctrl.pagination = PaginationFactory.fromHeaders(headers);
    ctrl.pagination.setPageChangeListener(listener);
    Page.title('Node', data.name);
  });
}]);
  
})();