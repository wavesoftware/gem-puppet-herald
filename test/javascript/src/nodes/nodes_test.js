'use strict';

describe('herald.nodes module', function() {
  beforeEach(module('herald.nodes'));
  describe('NodesController', function() {

    var controller, Page, $httpBackend;
    var defaultMockValues = [
      { name: 'master.cl.vm', no_of_reports: 12, status: 'unchanged', id: 1, last_run: '2014-01-01T12:34:56' },
      { name: 'db.cl.vm', no_of_reports: 5, status: 'failed', id: 2, last_run: '2014-01-01T12:24:36' },
      { name: 'app.cl.vm', no_of_reports: 10, status: 'pending', id: 3, last_run: '2014-01-01T12:14:46' }
    ];

    beforeEach(inject(function($injector) {

      // Set up the mock http service responses
      $httpBackend = $injector.get('$httpBackend');
      // Get hold of a scope (i.e. the root scope)
      var $rootScope = $injector.get('$rootScope');
      // The $controller service is used to create instances of controllers
      var $controller = $injector.get('$controller');

      Page = $injector.get('Page');

      controller = function(mockValues) {
        if (typeof(mockValues) === 'undefined') { mockValues = defaultMockValues; }
        // backend definition common for all tests
        $httpBackend.when('GET', '/api/v1/nodes')
                                .respond(mockValues);
        $httpBackend.expectGET('/api/v1/nodes');
        var ctrl = $controller('NodesController', { $scope : $rootScope });
        $httpBackend.flush();
        return ctrl;
      };
    }));

    afterEach(function() {
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    describe('fetching data from "/api/v1/nodes"', function() {
      it('there should be 3 nodes fetched', function() {
        expect(controller().all.length).toBe(3);
      });
      it('first should be named "master.cl.vm"', function() {
        expect(controller().all[0].name).toBe('master.cl.vm');
      });
    });
    it('should set Page.title to "All nodes"', function() {
      expect(controller()).not.toBe(undefined);
      expect(Page.actualTitle()).toEqual('All nodes');
      expect(Page.actualTarget()).toBe(undefined);
    });

    describe('on page change', function() {
      var ctrl;
      beforeEach(function() {
        ctrl = controller();
      });
      it('load a page from cache', function() {
        ctrl.onPageChange(1);
        expect(ctrl.all).toEqual(defaultMockValues);
      });
    });

  });
});