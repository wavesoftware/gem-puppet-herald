'use strict';

describe('herald module', function() {
  beforeEach(module('herald'));

  describe('AppController', function() {
    var controller, scope, Page;
    beforeEach(inject(function(_$controller_, _Page_) {
      var $controller = _$controller_;
      scope = {};
      controller = $controller('AppController', { $scope: scope });
      Page = _Page_;
    }));

    it('should have a `null` as page set by default', function() {
      expect(controller.page).toEqual(null);
    });

    it('should have ("Nodes", null), after Page.title("Nodes") call', function() {
      Page.title('Nodes');
      expect(controller.page).toEqual("Nodes");
      expect(controller.target).toEqual(undefined);
    });

    it('should have ("Report", 1234567), after Page.title("Report", 1234567) call', function() {
      Page.title('Report', 1234567);
      expect(controller.page).toEqual("Report");
      expect(controller.target).toEqual(1234567);
    });

    it('should have ("Node", "master"), after Page.title("Node", "master", " - ") call', function() {
      Page.title('Node', "master", ' - ');
      expect(controller.page).toEqual("Node");
      expect(controller.target).toEqual('master');
    });

  });

  describe('mapping of ui-router', function() {

    var $state, $stateParams, $location, $rootScope, navigateTo;
    beforeEach(module('nodes/nodes.html'));
    beforeEach(module('nodes/nodes.list.html'));
    beforeEach(module('node/node.html'));
    beforeEach(module('node/node.list.html'));
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

    it('state "nodes" should be abstract', function() {
      expect($state.get('nodes').abstract).toBeTruthy();
      expect($state.get('nodes').templateUrl).toEqual('nodes/nodes.html');
    });

    it('state "nodes.list" should match NodesController', function() {
      expect($state.get('nodes.list').controller).toEqual('NodesController');
      expect($state.get('nodes.list').templateUrl).toEqual('nodes/nodes.list.html');
    });

    it('state "nodes.node" should be abstract', function() {
      expect($state.get('nodes.node').abstract).toBeTruthy();
      expect($state.get('nodes.node').templateUrl).toEqual('node/node.html');
    });

    it('state "nodes.node.list" should match NodeController', function() {
      expect($state.get('nodes.node.list').controller).toEqual('NodeController');
      expect($state.get('nodes.node.list').templateUrl).toEqual('node/node.list.html');
    });

    it('state "nodes.node.report" should match ReportController', function() {
      expect($state.get('nodes.node.report').controller).toEqual('ReportController');
      expect($state.get('nodes.node.report').templateUrl).toEqual('report/report.html');
    });

    it('should not change address if given "/" and serve NodesController', function() {
      navigateTo('/');
      expect($state.$current.controller).toBe('NodesController');
      expect($state.$current.url.source).toBe('/');
    });

    it('should navigate to "/" if given "/non-existing-link-0" a address', function() {
      navigateTo('/non-existing-link-0');
      expect($state.$current.controller).toBe('NodesController');
      expect($state.$current.url.source).toBe('/');
    });

    it('should not change address if given "/node-1" a address', function() {
      navigateTo('/node-1');
      expect($state.$current.controller).toBe('NodeController');
      expect($state.$current.url.source).toBe('/node-{nodeId:int}');
      expect($stateParams.nodeId).toBe(1);
    });

    it('should not change address if given "/node-1/report-2" a address', function() {
      navigateTo('/node-1/report-2');
      expect($state.$current.controller).toBe('ReportController');
      expect($state.$current.url.source).toBe('/node-{nodeId:int}/report-{reportId:int}');
      expect($stateParams.nodeId).toBe(1);
      expect($stateParams.reportId).toBe(2);
    });

  });
});