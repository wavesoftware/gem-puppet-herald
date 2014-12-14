'use strict';

describe('herald.filters module', function() {
  beforeEach(module('herald.filters'));

  describe('capitalize filter', function() {

    var capitalize;

    beforeEach(inject(function($injector) {
      var $filter = $injector.get('$filter');
      capitalize = $filter('capitalize');
    }));

    it('should returns "" when given null', function() {
      expect(capitalize(null)).toEqual('');
    });

    it('should returns "" when given undefined', function() {
      expect(capitalize(undefined)).toEqual('');
    });

    it('should returns "Nodes" when given "nodes"', function() {
      expect(capitalize('nodes')).toEqual('Nodes');
    });

    it('should returns "Nodes" when given "Nodes"', function() {
      expect(capitalize('Nodes')).toEqual('Nodes');
    });

    it('should returns "Nodes" when given "NODES"', function() {
      expect(capitalize('NODES')).toEqual('NODES');
    });
  });
});
