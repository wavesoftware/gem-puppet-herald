(function() {

'use strict';

angular.module('herald.report', [
  'ui.router',
  'herald.page',
  'herald.directives'
])

.controller('ReportController', ['$http', '$stateParams', 'Page', function($http, $stateParams, Page) {
  var ctrl = this;
  Page.title('Puppet report');
  ctrl.report = null;
  this.reportId = $stateParams.reportId;

  $http.get('/api/v1/reports/' + this.reportId).success(function(data) {
    ctrl.report = data;
    Page.title('Puppet report', data.configuration_version);
  });
}]);

})();