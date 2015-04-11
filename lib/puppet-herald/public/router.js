(function(){
  'use strict';

  var router = angular.module('herald.router', [
    'ui.router',
    'herald.nodes',
    'herald.node',
    'herald.report',
    'ncy-angular-breadcrumb'
  ]);

  router.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');
    $stateProvider

      .state('home', {
        url: '/',
        abstract: true,
        templateUrl: 'general/app.html',
        ncyBreadcrumb: {
          label: 'Home page'
        }
      })

      .state('nodes', {
        url: '',
        templateUrl: 'nodes/nodes.html',
        controller: 'NodesController as ctrl',
        parent: 'home',
        ncyBreadcrumb: {
          label: 'All Puppet nodes'
        }
      })

      .state('node', {
        url: 'node-{nodeId:int}',
        templateUrl: 'node/node.html',
        controller: 'NodeController as ctrl',
        parent: 'nodes',
        ncyBreadcrumb: {
          label: "All node's reports"
        }
      })

      .state('report', {
        parent: 'node',
        url: '/report-{reportId:int}',
        templateUrl: 'report/report.html',
        controller: 'ReportController as ctrl',
        ncyBreadcrumb: {
          label: 'Report'
        }
      })

    ;
  }]);

})();