(function() {

'use strict';

angular.module('herald.report', [
  'ui.router',
  'herald.page',
  'herald.directives'
])

.config(['$stateProvider', function($stateProvider) {
  $stateProvider
  .state('nodes.node.report', {
    url: '/report-{reportId:int}',
    templateUrl: 'report/report.html',
    controller: 'ReportController'
  });
}])

.controller('ReportController', ['$http', '$stateParams', 'Page', function($http, $stateParams, Page) {
  Page.title('Report');
  var ctrl = this;
  ctrl.report = null;
  this.reportId = $stateParams.reportId;

  $http.get('/api/v1/reports/' + this.reportId).success(function(data) {
    ctrl.report = data;
    Page.title('Report', data.configuration_version);
  });
}]);

})();