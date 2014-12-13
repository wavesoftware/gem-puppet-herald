'use strict';

describe('herald.artifact module', function() {
  beforeEach(module('myApp.artifact'));

  describe('app-version directive', function() {
    it('should print current version', function() {
      module(function($provide) {
        $provide.value('artifact', { version: 'TEST_VER' });
      });
      inject(function($compile, $rootScope) {
        var element = $compile('<span app-version></span>')($rootScope);
        expect(element.text()).toEqual('TEST_VER');
      });
    });
  });
});
