(function() {

'use strict';

angular.module('herald.nodes', [
  'ui.router',
  'herald.directives',
  'herald.page',
  'herald.pagination',
  'angularMoment'
])

.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
  $stateProvider
  .state('nodes', {
    url: '/',
    abstract: true,
    templateUrl: 'nodes/nodes.html'
  })
  .state('nodes.list', {
    url: '',
    templateUrl: 'nodes/nodes.list.html',
    controller: 'NodesController'
  });
}])

.controller('NodesController', ['$http', 'Page', 'PaginationFactory', function($http, Page, PaginationFactory) {
  Page.title('All nodes');
  var ctrl = this;
  ctrl.pagination = PaginationFactory.DEFAULT;
  ctrl.cache = PaginationFactory.createPageCache(60); // 60 seconds cache
  ctrl.all = [];

  function getResultsPage(pageNumber) {
    ctrl.pagination.page(pageNumber);
    if (ctrl.cache.isLoaded(pageNumber)) {
      ctrl.all = ctrl.cache.get(pageNumber);
      return;
    }
    var config = { headers: ctrl.pagination.toHeaders() };
    $http.get('/api/v1/nodes', config).success(function(data, status, headers, config) {
      ctrl.all = data;
      ctrl.pagination = PaginationFactory.fromHeaders(headers);
      var loadedPage = ctrl.pagination.page();
      ctrl.cache.set(loadedPage, data);
    });
  }
  getResultsPage(ctrl.pagination.page());
  ctrl.onPageChange = function(newPage) {
    getResultsPage(newPage);
  };
}]);

})();