'use strict';

describe('herald.artifact module', function() {
  beforeEach(module('herald.artifact'));

  describe('ArtifactController', function() {

    var $httpBackend, $rootScope, createController, authRequestHandler;

    var mockValues = {
      version: 'TEST_VER',
      homepage: 'http://example.org/herald',
      summary: 'herald',
      package: 'herald',
      license: 'Apache 2.0',
      name:    'Puppet Herald'
    };

    beforeEach(inject(function($injector) {

      // Set up the mock http service responses
      $httpBackend = $injector.get('$httpBackend');
      // backend definition common for all tests
      authRequestHandler = $httpBackend.when('GET', '/version.json')
                              .respond(mockValues);

      // Get hold of a scope (i.e. the root scope)
      $rootScope = $injector.get('$rootScope');
      // The $controller service is used to create instances of controllers
      var $controller = $injector.get('$controller');

      createController = function() {
        $httpBackend.expectGET('/version.json');
        var controller = $controller('ArtifactController', {'$scope' : $rootScope });
        $httpBackend.flush();
        return controller;
      };
    }));

    afterEach(function() {
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    it('should fetch version of artifact', function() { 
      expect(createController().version).toBe(mockValues.version);
    });
    it('should fetch homepage of artifact', function() { 
      expect(createController().homepage).toBe(mockValues.homepage);
    });
    it('should fetch package of artifact', function() { 
      expect(createController().package).toBe(mockValues.package);
    });
    it('should fetch summary of artifact', function() { 
      expect(createController().summary).toBe(mockValues.summary);
    });
    it('should fetch license of artifact', function() { 
      expect(createController().license).toBe(mockValues.license);
    });
    it('should fetch name of artifact', function() { 
      expect(createController().name).toBe(mockValues.name);
    });
  });
});
