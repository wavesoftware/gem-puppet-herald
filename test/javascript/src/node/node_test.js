'use strict';

describe('herald.node module', function() {
  beforeEach(module('herald.node'));
  describe('NodeController', function() {

    var controller, Page, $httpBackend;
    var defaultMockValues = {
      name: 'master.cl.vm', 
      no_of_reports: 2, 
      status: 'unchanged', 
      id: 1, 
      last_run: '2014-01-01T12:34:56',
      reports: [
        { configuration_version: '1234578', status: 'unchanged', environment: 'production', time: '2014-01-01T12:34:56', id: 2 },
        { configuration_version: '1234556', status: 'pending', environment: 'production', time: '2014-01-01T12:24:16', id: 1 },
      ]
    };

    beforeEach(inject(function($injector) {

      // Set up the mock http service responses
      $httpBackend = $injector.get('$httpBackend');
      // Get hold of a scope (i.e. the root scope)
      var $rootScope = $injector.get('$rootScope');
      // The $controller service is used to create instances of controllers
      var $controller = $injector.get('$controller');

      var $stateParams = $injector.get('$stateParams');

      Page = $injector.get('Page');

      controller = function(id, mockValues) {
        if (id == null) { id = 1; }
        if (typeof(mockValues) === 'undefined') { mockValues = defaultMockValues; }

        $stateParams.nodeId = id;
        // backend definition common for all tests
        var handler = $httpBackend.when('GET', '/api/v1/nodes/' + id);
        if (mockValues != null) {
          handler.respond(mockValues);
        } else {
          handler.respond(404, null);
        }
        $httpBackend.expectGET('/api/v1/nodes/' + id);
        var ctrl = $controller('NodeController', { $scope : $rootScope });
        $httpBackend.flush();
        return ctrl;
      };
    }));

    afterEach(function() {
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    describe('fetching data from "/api/v1/nodes/1"', function() {
      it('there should be node fetched', function() {
        expect(controller().node).not.toEqual(null);
      });
      it('should have fetch 2 reports', function() {
        var ctrl = controller();
        expect(ctrl.node.reports.length).toBe(2);
        expect(ctrl.node.no_of_reports).toBe(2);
      });
      it('should set Page.title to "Node: master.cl.vm"', function() {
        expect(controller()).not.toBe(undefined);
        expect(Page.actualTitle()).toEqual('Node');
        expect(Page.actualTarget()).toBe('master.cl.vm');
      });
    });
    describe('fetching data from "/api/v1/nodes/12"', function() {
      var ctrl;
      beforeEach(function() {
        ctrl = controller(12, null);
      });
      it('there should not be node fetched', function() {
        expect(ctrl.node).toEqual(null);
      });
      it('should set Page.title to "Node: "', function() {
        expect(ctrl).not.toBe(undefined);
        expect(Page.actualTitle()).toEqual('Node');
        expect(Page.actualTarget()).toBe(undefined);
      });
    });
    describe('on page change', function() {
      var ctrl;
      beforeEach(function() {
        ctrl = controller();
      });
      it('load a page from cache', function() {
        ctrl.onPageChange(1);
        expect(ctrl.node).toEqual(defaultMockValues);
      });
    });
  });
});