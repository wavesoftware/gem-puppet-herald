(function(){
  'use strict';

  var app = angular.module('herald' , [
    'ngRoute',
    'herald.nodes',
    'herald.node',
    'herald.report',
    'herald.filters',
    'herald.artifact'
  ]);

  app.config(['$routeProvider', function($routeProvider) {
    $routeProvider.otherwise({redirectTo: '/nodes'});
  }]);

  app.factory('appService', function() {  
    return {
        page: 'home'
    };
  });

  app.controller('AppController', ['appService', function(appService) {
    this.page = appService.page;
  }]);

})();