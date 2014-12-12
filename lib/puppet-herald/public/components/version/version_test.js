'use strict';

describe('herald.version module', function() {
  beforeEach(module('herald.version'));

  describe('version service', function() {
    it('should return current version', inject(function(version) {
      expect(version).toEqual('0.1.0');
    }));
  });
});
