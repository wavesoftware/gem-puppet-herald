'use strict';

angular.module('herald.filters', [
])

.filter('capitalize', function() {
  return function(input) {
    var first = input.substring(0, 1);
    var rest = input.substring(1);
    return first.toUpperCase() + rest;
  };
});