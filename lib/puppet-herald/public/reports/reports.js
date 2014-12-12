'use strict';

angular.module('herald.reports', [
  'ngRoute',
  'herald.directives'
])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/reports', {
    templateUrl: 'reports/reports.html',
    controller: 'ReportsController'
  });
}])

.controller('ReportsController', ['$http', 'appService', function($http, appService) {
  appService.page = 'reports';
  var ctrl = this;
  ctrl.node = null;

  $http.get('/api/v1/node/1').success(function(data) {
    ctrl.node = data;
  });
}]);