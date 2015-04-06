(function() {

'use strict';

angular.module('herald.report', [
  'ngRoute',
  'herald.page',
  'herald.directives'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/report/:reportId', {
    templateUrl: 'report/report.html',
    controller: 'ReportController'
  });
}])

.controller('ReportController', ['$http', '$routeParams', 'Page', function($http, $routeParams, Page) {
  Page.title('Report');
  var ctrl = this;
  ctrl.report = null;
  this.reportId = $routeParams.reportId;

  $http.get('/api/v1/reports/' + this.reportId).success(function(data) {
    ctrl.report = data;
    Page.title('Report', data.configuration_version);
  });
}]);

})();