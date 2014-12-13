'use strict';

angular.module('herald.report', [
  'ngRoute',
  'herald.directives'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/report/:reportId', {
    templateUrl: 'report/report.html',
    controller: 'ReportController'
  });
}])

.controller('ReportController', ['$http', '$routeParams', function($http, $routeParams) {
  var ctrl = this;
  ctrl.report = null;

  this.reportId = $routeParams.reportId;

  $http.get('/api/v1/report/' + this.reportId).success(function(data) {
    ctrl.report = data;
  });
}]);