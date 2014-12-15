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

    it('should have a ("Nodes", null) as page set, if Page.title("Nodes") was called before', function() {
      Page.title('Nodes');
      expect(controller.page).toEqual("Nodes");
      expect(controller.target).toEqual(undefined);
    });

    it('should have a ("Report", 1234567) as page set, if Page.title("Report", 1234567) was called before', function() {
      Page.title('Report', 1234567);
      expect(controller.page).toEqual("Report");
      expect(controller.target).toEqual(1234567);
    });

    it('should have a ("Node", "master") as page set, if Page.title("Node", "master", " - ") was called before', function() {
      Page.title('Node', "master", ' - ');
      expect(controller.page).toEqual("Node");
      expect(controller.target).toEqual('master');
    });

  });

  describe('routes mapping', function() {

    var $route, $location, $rootScope, navigateTo;
    beforeEach(module('nodes/nodes.html'));
    beforeEach(module('node/node.html'));
    beforeEach(module('report/report.html'));
    beforeEach(inject(function(_$route_, _$location_, _$rootScope_) {
      $route = _$route_;
      $location = _$location_;
      $rootScope = _$rootScope_;
      navigateTo = function(address) {
        expect($route.current).toBeUndefined();
        $location.path(address);
        $rootScope.$digest();
      };
    }));

    it('should map NodesController for unknown address', function() {
      expect($route.routes[null].redirectTo).toEqual('/nodes');
    });
    it('should map NodesController if given "/nodes"', function() {
      expect($route.routes['/nodes'].controller).toBe('NodesController');
    });

    it('should navigate to "/nodes" if given "/" a address', function() {
      navigateTo('/');
      expect($route.current.controller).toBe('NodesController');
      expect($route.current.originalPath).toBe('/nodes');
    });

    it('should navigate to "/nodes" if given "/non-existing-link-0" a address', function() {
      navigateTo('/non-existing-link-0');
      expect($route.current.controller).toBe('NodesController');
      expect($route.current.originalPath).toBe('/nodes');
    });

    it('should navigate to "/node/1" if given "/node/1" a address', function() {
      navigateTo('/node/1');
      expect($route.current.controller).toBe('NodeController');
      expect($route.current.originalPath).toBe('/node/:nodeId');
      expect($route.current.pathParams.nodeId).toBe('1');
    });

    it('should navigate to "/report/1" if given "/report/1" a address', function() {
      navigateTo('/report/1');
      expect($route.current.controller).toBe('ReportController');
      expect($route.current.originalPath).toBe('/report/:reportId');
      expect($route.current.pathParams.reportId).toBe('1');
    });

  });
});