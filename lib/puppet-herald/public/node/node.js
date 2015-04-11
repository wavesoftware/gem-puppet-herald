(function() {

'use strict';

angular.module('herald.node', [
  'ui.router',
  'herald.page',
  'herald.directives',
  'herald.pagination',
  'angularMoment'
])

.controller('NodeController', 
    ['$http', '$stateParams', 'Page', 'PaginationFactory', 
        function($http, $stateParams, Page, PaginationFactory) {

  var ctrl = this;
  Page.title('All reported jobs');
  ctrl.pagination = PaginationFactory.DEFAULT;
  ctrl.cache = PaginationFactory.createPageCache(60); // 60 seconds cache
  ctrl.node = null;
  this.nodeId = $stateParams.nodeId;
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
      Page.title('All reported jobs', data.name);
      ctrl.cache.set(loadedPage, data);
    });
  }
  getResultsPage(ctrl.pagination.page());
  ctrl.onPageChange = function(newPage) {
    getResultsPage(newPage);
  };
}]);
  
})();