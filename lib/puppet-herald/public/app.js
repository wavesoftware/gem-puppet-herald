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

  app.factory('Page', ['$document', '$rootScope', function($document, $rootScope) {
    var root = $document;
    var base = root[0].title
    var title = null;
    var target = null;
    var service = {
      title: function(newTitle, newTarget, joiner) {
        var merged = newTitle + '';
        if(typeof(joiner) === 'undefined') joiner = ': ';
        if (typeof(newTarget) !== 'undefined') {
          merged = merged + joiner + newTarget;
        }
        var whole = merged + ' | ' + base;
        root[0].title = whole;
        title = newTitle;
        target = newTarget;
        $rootScope.$emit('Page::titleChanged', title, target, merged, whole);
      }
    };
    return service;
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