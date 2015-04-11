'use strict';

describe('herald.directives module', function() {
  beforeEach(module('herald.directives'));

  describe('herald.directives.status-button module', function() {

    beforeEach(module('herald.directives.status-button'));

    describe('StatusButtonController', function() {
      var controller, scope, state;
      
      beforeEach(inject(function($injector) {
        var $controller = $injector.get('$controller');
        var $rootScope = $injector.get('$rootScope');
        state = $injector.get('$state');
        $rootScope.$on('$locationChangeStart', function(event, args) {
          event.preventDefault();
        })
        var $scope = {};
        scope = $scope;
        controller = $controller('StatusButtonController', { $scope: $scope });
      }));

      it('should navigate to "/node-112" after issuing navigate() function', function() {
        spyOn(state, 'go').and.returnValue(null);
        expect(scope.navigate('nodes.node', 'nodeId', 112)).toBe(undefined);
        expect(state.go).toHaveBeenCalledWith('nodes.node', { nodeId: 112 });
      });

    });

    describe('colorizeStatus filter', function() {

      var colorizeStatus;

      beforeEach(inject(function($injector) {
        var $filter = $injector.get('$filter');
        colorizeStatus = $filter('colorizeStatus');
      }));

      it('should returns "default" when given null', function() {
        expect(colorizeStatus(null)).toEqual('default');
      });
      it('should returns "default" when given undefined', function() {
        expect(colorizeStatus(undefined)).toEqual('default');
      });
      it('should returns "default" when given undefined', function() {
        expect(colorizeStatus('unknown')).toEqual('default');
      });
      it('should returns "success" when given "unchanged"', function() {
        expect(colorizeStatus('unchanged')).toEqual('success');
      });
      it('should returns "info" when given "changed"', function() {
        expect(colorizeStatus('changed')).toEqual('info');
      });
      it('should returns "danger" when given "failed"', function() {
        expect(colorizeStatus('failed')).toEqual('danger');
      });
      it('should returns "warning" when given "pending"', function() {
        expect(colorizeStatus('pending')).toEqual('warning');
      });
    });

    describe('iconizeStatus filter', function() {

      var iconizeStatus;

      beforeEach(inject(function($injector) {
        var $filter = $injector.get('$filter');
        iconizeStatus = $filter('iconizeStatus');
      }));

      it('should returns "sign" when given null', function() {
        expect(iconizeStatus(null)).toEqual('sign');
      });
      it('should returns "sign" when given undefined', function() {
        expect(iconizeStatus(undefined)).toEqual('sign');
      });
      it('should returns "sign" when given undefined', function() {
        expect(iconizeStatus('unknown')).toEqual('sign');
      });
      it('should returns "ok" when given "unchanged"', function() {
        expect(iconizeStatus('unchanged')).toEqual('ok');
      });
      it('should returns "pencil" when given "changed"', function() {
        expect(iconizeStatus('changed')).toEqual('pencil');
      });
      it('should returns "remove" when given "failed"', function() {
        expect(iconizeStatus('failed')).toEqual('remove');
      });
      it('should returns "asterisk" when given "pending"', function() {
        expect(iconizeStatus('pending')).toEqual('asterisk');
      });
    });

    describe('wsStatusButton directive', function() {

      var elm, scope, button;
      beforeEach(module('components/directives/status-button.html'));
      beforeEach(inject(function($rootScope, $compile){
        var tpl = '<ws-status-button status="node.status" id="node.id" route="\'/node/:id\'"></ws-status-button>';
        elm = angular.element(tpl);
        scope = $rootScope;
        $compile(elm)(scope);
        scope.$digest();
        button = elm.find('button');
      }));

      describe('with scope without any values', function() {

        it('should embed a one element of type "button"', function() {
          expect(button.length).toBe(1);
        });
        it('should embed an element with class "btn-default"', function() {
          expect(button.hasClass('btn-default')).toBe(true);
        });
        it('should embed an element with class "glyphicon-sign"', function() {
          expect(button.hasClass('glyphicon-sign')).toBe(true);
        });
        it('should embed a button with text " "', function() {
          expect(button.text()).toEqual(' ');
        });

      });

      describe('with values { status: "unchanged", id: 16 } given', function() {

        beforeEach(function() {
          scope.$apply(function() {
            scope.node = {
              status: "unchanged",
              id: 16
            };
          });
        });

        it('should embed a one element of type "button"', function() {
          expect(button.length).toBe(1);
        });
        it('should embed an element with class "btn-success"', function() {
          expect(button.hasClass('btn-success')).toBe(true);
        });
        it('should embed an element with class "glyphicon-ok"', function() {
          expect(button.hasClass('glyphicon-ok')).toBe(true);
        });
        it('should embed a button with text " UNCHANGED"', function() {
          expect(button.text()).toEqual(' UNCHANGED');
        });
        it('should embed a button with onclick == "navigate(route, idname, id)"', function() {
          expect(button.attr('ng-click')).toEqual("navigate(route, idname, id)");
        });

      });

    });
  });

});