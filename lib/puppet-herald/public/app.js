(function(){
  'use strict';

  var app = angular.module('herald' , [
    'ngRoute',
    'herald.nodes',
    'herald.reports',
    'herald.filters',
    'herald.version'
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