(function(){
  'use strict';

  var app = angular.module('herald' , [
    'ngRoute',
    'herald.page',
    'herald.nodes',
    'herald.node',
    'herald.report',
    'herald.filters',
    'herald.artifact'
  ]);

  app.config(['$routeProvider', function($routeProvider) {
    $routeProvider.otherwise({redirectTo: '/nodes'});
  }]);

  app.controller('AppController', ['Page', '$rootScope', function(Page, $rootScope) {
    var ctrl = this;
    this.page = null;
    this.target = null;
    $rootScope.$on('Page::titleChanged', function(event, title, target) {
      ctrl.page = title;
      ctrl.target = target;
    });
  }]);

})();