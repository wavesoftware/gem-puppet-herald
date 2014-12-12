'use strict';

(function(){

  'use strict';

  var versionModule = angular.module('herald.version', [
    'herald.version.interpolate-filter',
    'herald.version.version-directive'
  ]);

  versionModule.value('version', '0.1.0');

})();
