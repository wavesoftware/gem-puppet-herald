(function(){
  'use strict';

  var app = angular.module('herald' , [
    'ui.router',
    'herald.router',
    'herald.page',
    'herald.settings',
    'herald.nodes',
    'herald.node',
    'herald.report',
    'herald.filters',
    'herald.artifact'
  ]);

  app.controller('AppController', 
    ['Page', '$rootScope', 'Settings', '$scope',
      function(Page, $rootScope, Settings, $scope) {

    var ctrl = this;
    $scope.page = null;
    $scope.target = null;
    $scope.settings = Settings;
    $rootScope.$on('Page::titleChanged', function(event, title, target) {
      $scope.page = title;
      $scope.target = target;
    });
  }]);

})();