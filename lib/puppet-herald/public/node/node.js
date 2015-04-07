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
  ctrl.cache = PaginationFactory.createPageCache(60); // 60 seconds cache
  ctrl.node = null;
  Page.title('Node');
  this.nodeId = $routeParams.nodeId;
  var gateway = '/api/v1/nodes/' + this.nodeId;

  function getResultsPage(pageNumber) {
    ctrl.pagination.page(pageNumber);
    if (ctrl.cache.isLoaded(pageNumber)) {
      ctrl.node = ctrl.cache.get(pageNumber);
      return;
    }
    var config = { headers: ctrl.pagination.toHeaders() };
    $http.get(gateway, config).success(function(data, status, headers, config) {
      ctrl.node = data;
      ctrl.pagination = PaginationFactory.fromHeaders(headers);
      var loadedPage = ctrl.pagination.page();
      Page.title('Node', data.name);
      ctrl.cache.set(loadedPage, data);
    });
  }
  getResultsPage(ctrl.pagination.page());
  ctrl.onPageChange = function(newPage) {
    getResultsPage(newPage);
  };
}]);
  
})();