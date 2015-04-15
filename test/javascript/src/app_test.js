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
      expect(scope.page).toEqual(null);
    });

    it('should have ("Nodes", null), after Page.title("Nodes") call', function() {
      Page.title('Nodes');
      expect(scope.page).toEqual("Nodes");
      expect(scope.target).toEqual(undefined);
    });

    it('should have ("Report", 1234567), after Page.title("Report", 1234567) call', function() {
      Page.title('Report', 1234567);
      expect(scope.page).toEqual("Report");
      expect(scope.target).toEqual(1234567);
    });

    it('should have ("Node", "master"), after Page.title("Node", "master", " - ") call', function() {
      Page.title('Node', "master", ' - ');
      expect(scope.page).toEqual("Node");
      expect(scope.target).toEqual('master');
    });

  });

});