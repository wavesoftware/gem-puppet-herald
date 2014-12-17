'use strict';

describe('herald.artifact module', function() {
  beforeEach(module('herald.artifact'));

  describe('app-version directive', function() {

    var $controller, $compile, $rootScope;
    // Store references to $rootScope and $compile
    // so they are available to all tests in this describe block
    beforeEach(inject(function(_$compile_, _$controller_, _$rootScope_){
      // The injector unwraps the underscores (_) from around the parameter names when matching
      $compile = _$compile_;
      $controller = _$controller_;
      $rootScope = _$rootScope_;
    }));

    it('should print current version', function() {

      inject(function($compile, $rootScope, $injector) {
        // Set up the mock http service responses
        var $httpBackend = $injector.get('$httpBackend');
        // backend definition common for all tests
        var authRequestHandler = $httpBackend.when('GET', '/version.json')
                              .respond({version: 'TEST_VER'});
        $httpBackend.expectGET('/version.json');

        var element = $compile('<div><span app-version></span></div>')($rootScope);
        expect(element.text()).toEqual('{{ artifact.version }}');
        // fire all the watches, so the scope expression {{ artifact.version }} will be evaluated
        $rootScope.$digest();
        expect(element.text()).toEqual('0.0.0');
      });
    });
  });
});
