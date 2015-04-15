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
  ctrl.nav = {
    node: null,
    report: null
  };
  this.reportId = $stateParams.reportId;

  function setReport(reportData) {
    ctrl.report = reportData;
    ctrl.nav.node = ctrl.report.host;
    ctrl.nav.report = ctrl.report.configuration_version;
  }

  $http.get('/api/v1/reports/' + this.reportId).success(function(data) {
    setReport(data);
    Page.title('Puppet report', data.configuration_version);
  });
}]);

})();