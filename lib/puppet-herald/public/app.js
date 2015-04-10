(function(){
  'use strict';

  var app = angular.module('herald' , [
    'ui.router',
    'herald.page',
    'herald.nodes',
    'herald.node',
    'herald.report',
    'herald.filters',
    'herald.artifact'
  ]);

  app.config(['$urlRouterProvider', function($urlRouterProvider) {
    $urlRouterProvider.otherwise('/');
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