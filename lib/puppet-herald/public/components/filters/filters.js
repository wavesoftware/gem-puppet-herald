'use strict';

angular.module('herald.filters', [])

.filter('capitalize', function() {
  return function(input) {
    var text;
    if (input == null) {
      text = '';
    } else {
      text = input.toString();
    }
    var first = text.substring(0, 1);
    var rest = text.substring(1);
    return first.toUpperCase() + rest;
  };
});