'use strict';

describe('herald.router module', function() {
  beforeEach(module('herald.router'));

  describe('mapping of ui-router', function() {

    var $state, $stateParams, $location, $rootScope, navigateTo;
    beforeEach(module('general/app.html'));
    beforeEach(module('nodes/nodes.html'));
    beforeEach(module('node/node.html'));
    beforeEach(module('report/report.html'));
    beforeEach(inject(function(_$state_, _$location_, _$rootScope_, _$stateParams_) {
      $state = _$state_;
      $location = _$location_;
      $rootScope = _$rootScope_;
      $stateParams = _$stateParams_;
      navigateTo = function(address) {
        $location.path(address);
        $rootScope.$digest();
      };
    }));

    it('should map "/" for unknown address', function() {
      var invalid = 'non-existing';
      expect($state.href(invalid)).toBe(null);
      navigateTo(invalid);
      expect($state.$current.url.source).toEqual('/');
    });

    it('state "home" should be abstract', function() {
      expect($state.get('home').abstract).toBeTruthy();
      expect($state.get('home').url).toEqual('/');
    });

    it('state "nodes" should match NodesController', function() {
      expect($state.get('nodes').controller).toEqual('NodesController as ctrl');
      expect($state.get('nodes').templateUrl).toEqual('nodes/nodes.html');
    });

    it('state "nodes.node" should match NodeController', function() {
      expect($state.get('node').controller).toEqual('NodeController as ctrl');
      expect($state.get('node').templateUrl).toEqual('node/node.html');
    });

    it('state "nodes.node.report" should match ReportController', function() {
      expect($state.get('report').controller).toEqual('ReportController as ctrl');
      expect($state.get('report').templateUrl).toEqual('report/report.html');
    });

    it('should not change address if given "/" and serve NodesController', function() {
      navigateTo('/');
      expect($state.$current.controller).toBe('NodesController as ctrl');
      expect($state.$current.url.source).toBe('/');
    });

    it('should navigate to "/" if given "/non-existing-link-0" a address', function() {
      navigateTo('/non-existing-link-0');
      expect($state.$current.controller).toBe('NodesController as ctrl');
      expect($state.$current.url.source).toBe('/');
    });

    it('should not change address if given "/node-1" a address', function() {
      navigateTo('/node-1');
      expect($state.$current.controller).toBe('NodeController as ctrl');
      expect($state.$current.url.source).toBe('/node-{nodeId:int}');
      expect($stateParams.nodeId).toBe(1);
    });

    it('should not change address if given "/node-1/report-2" a address', function() {
      navigateTo('/node-1/report-2');
      expect($state.$current.controller).toBe('ReportController as ctrl');
      expect($state.$current.url.source).toBe('/node-{nodeId:int}/report-{reportId:int}');
      expect($stateParams.nodeId).toBe(1);
      expect($stateParams.reportId).toBe(2);
    });

  });
});