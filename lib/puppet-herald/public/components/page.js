(function(angular){
  'use strict';

  var module = angular.module('herald.page' , []);

  module.factory('Page', ['$document', '$rootScope', function($document, $rootScope) {
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
      },
      actualTitle: function() {
        return title;
      },
      actualTarget: function() {
        return target;
      }
    };
    return service;
  }]);

})(angular);