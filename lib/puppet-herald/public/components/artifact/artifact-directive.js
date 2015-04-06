(function(){

'use strict';

angular.module('herald.artifact.artifact-directive', [])

.directive('appVersion', function() {
  return {
    restrict: 'A',
    controller: 'ArtifactController as artifact',
    transclude: true,
    template: '<span>{{ artifact.version }}</span>'
  };
});

})();
