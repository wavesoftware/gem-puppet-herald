(function(){

  'use strict';

  var module = angular.module('herald.artifact', [
    'herald.artifact.artifact-directive'
  ]);

  module.controller('ArtifactController', ['$http', function($http) {
    this.version  = '0.0.0';
    this.homepage = '#';
    this.summary  = null;
    this.package  = null;
    this.license  = null;
    this.name     = null;

    var self = this;

    $http.get('/version.json').success(function(data) {
      self.version  = data.version;
      self.homepage = data.homepage;
      self.summary  = data.summary;
      self.package  = data.package;
      self.license  = data.license;
      self.name     = data.name;
    });
  }]);

})();
