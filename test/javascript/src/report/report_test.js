'use strict';

describe('herald.report module', function() {
  beforeEach(module('herald.report'));
  describe('ReportController', function() {

    var controller, Page, $httpBackend;
    var defaultMockValues = { 
      configuration_version: '1234578', 
      status: 'changed', 
      environment: 'production', 
      time: '2014-01-01T12:34:56', 
      puppet_version: '3.7.3',
      host: 'master.cl.vm',
      kind: 'apply',
      id: 2,
      log_entries: [
        { level: 'debug', message: 'Stating compile', source: 'Puppet' },
        { level: 'info', message: 'Compiled configuration version: "1234578" for environment production', source: 'Puppet' },
        { level: 'notice', message: 'changed from "abc" to "bcd"', source: 'Stage[main]/Users/User[root]/shell' },
        { level: 'notice', message: 'Config processed in 4.32 sec.', source: '' },
      ]
    };

    beforeEach(inject(function($injector) {

      // Set up the mock http service responses
      $httpBackend = $injector.get('$httpBackend');
      // Get hold of a scope (i.e. the root scope)
      var $rootScope = $injector.get('$rootScope');
      // The $controller service is used to create instances of controllers
      var $controller = $injector.get('$controller');

      var $routeParams = $injector.get('$routeParams');

      Page = $injector.get('Page');

      controller = function(id, mockValues) {
        if (id == null) { id = 1; }
        if (typeof(mockValues) === 'undefined') { mockValues = defaultMockValues; }

        $routeParams.reportId = id;
        // backend definition common for all tests
        var handler = $httpBackend.when('GET', '/api/v1/report/' + id);
        if (mockValues != null) {
          handler.respond(mockValues);
        } else {
          handler.respond(404, null);
        }
        $httpBackend.expectGET('/api/v1/report/' + id);
        var ctrl = $controller('ReportController', { $scope : $rootScope });
        $httpBackend.flush();
        return ctrl;
      };
    }));

    afterEach(function() {
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    describe('fetching data from "/api/v1/report/1"', function() {
      var ctrl;
      beforeEach(function() {
        ctrl = controller();
      });
      it('there should be report fetched', function() {
        expect(ctrl.report).not.toEqual(null);
      });
      it('should have fetch report with 4 lines', function() {
        expect(ctrl.report.log_entries.length).toBe(4);
      });
      it('should set Page.title to "Report: 1234578"', function() {
        expect(ctrl).not.toBe(undefined);
        expect(Page.actualTitle()).toEqual('Report');
        expect(Page.actualTarget()).toBe('1234578');
      });
    });
    describe('fetching data from "/api/v1/report/12"', function() {
      var ctrl;
      beforeEach(function() {
        ctrl = controller(12, null);
      });
      it('there should not be report fetched', function() {
        expect(ctrl.report).toEqual(null);
      });
      it('should set Page.title to "Report: "', function() {
        expect(ctrl).not.toBe(undefined);
        expect(Page.actualTitle()).toEqual('Report');
        expect(Page.actualTarget()).toBe(undefined);
      });
    });
  });
});