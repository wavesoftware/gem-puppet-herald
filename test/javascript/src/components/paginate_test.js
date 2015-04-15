'use strict';

describe('herald.pagination module', function() {
  beforeEach(module('herald.pagination'));

  describe('PaginationFactory factory', function() {
    var PaginationFactory;

    beforeEach(inject(function(_PaginationFactory_){
      // The injector unwraps the underscores (_) from around the parameter names when matching
      PaginationFactory = _PaginationFactory_;
    }));

    it('should be injected', function() {
      expect(PaginationFactory).not.toBeUndefined();
    });

    describe('DEFAULT pagination', function() {
      var subject;
      beforeEach(function() {
        subject = PaginationFactory.DEFAULT;
      });
      it('page is 1', function() {
         expect(subject.page()).toBe(1);
      });
      it('limit is 15', function() {
         expect(subject.limit()).toBe(15);
      });
    });

    describe('create()', function() {
      describe('invalid cases', function() {
        it('raise error on page == 0', function() {
          expect( function() { PaginationFactory.create(0, 1) } )
            .toThrow(new TypeError("Value for pagination page is invalid: 0"));
        });
        it('raise error on page == -9', function() {
          expect( function() { PaginationFactory.create(-9, 5) } )
            .toThrow(new TypeError("Value for pagination page is invalid: -9"));
        });

        it('raise error on limit == 0', function() {
          expect( function() { PaginationFactory.create(1, 0) } )
            .toThrow(new TypeError("Value for pagination limit is invalid: 0"));
        });
        it('raise error on limit == -9', function() {
          expect( function() { PaginationFactory.create(1, -9) } )
            .toThrow(new TypeError("Value for pagination limit is invalid: -9"));
        });
        it('raise error on limit == marie', function() {
          expect( function() { PaginationFactory.create(1, 'marie') } )
            .toThrow(new TypeError("Value for pagination limit is invalid: marie"));
        });

        it('raise error on limit == -19 and page == john', function() {
          expect( function() { PaginationFactory.create('john', -19) } )
            .toThrow(new TypeError("Value for pagination page is invalid: john"));
        });
      });
      describe('valid created object', function() {
        var first, second, counter, lastPage;
        beforeEach(function() {
          counter = 0;
          lastPage = undefined;
          first = PaginationFactory.create(1, 10);
          second = PaginationFactory.create(2, 10);
          second.setPageChangeListener(function(candidate) {
            counter++;
            lastPage = candidate;
          });
        });
        it('raise error while setting page to jil', function() {
          expect( function() { second.page('jil') } )
            .toThrow(new TypeError("Value for pagination page is invalid: jil"));
        });
        it('should not have next pages', function() {
          expect(first.hasNext()).toBe(false);
        });
        it('first page dont have previous one', function() {
          expect( first.hasPrevious() ).toBe(false);
        });
        it('second page dont have previous one', function() {
          expect( second.hasPrevious() ).toBe(true);
        });

        it('run listeners on object with them', function() {
          expect(counter).toEqual(0);
          expect(lastPage).toBeUndefined();
          expect(second.page()).toEqual(2);
          second.next();
          expect(second.page()).toEqual(3);
          second.next();
          expect(second.page()).toEqual(4);
          expect(counter).toEqual(2);
          expect(lastPage).toBe(4);
        });

        it('dont run listeners on object without them', function() {
          expect(counter).toEqual(0);
          expect(lastPage).toBeUndefined();
          expect(first.page()).toEqual(1);
          first.next();
          expect(first.page()).toEqual(2);
          expect(counter).toEqual(0);
          expect(lastPage).toBeUndefined();
        });

        it('second page paginate backwards to first', function() {
          expect( second.page() ).toBe(2);
          second.previous();
          expect( second.page() ).toBe(1);
        });

        it('page value is expected', function() {
          expect( second.page() ).toBe(2);
        });

        it('page sets to 7', function() {
          expect( second.page(7) ).toBe(7);
        });
        it('limit value is expected', function() {
          expect( second.limit() ).toBe(10);
        });

        it('elements value is null', function() {
          expect( second.elements() ).toBeNull();
        });
        it('pages value is null', function() {
          expect( second.pages() ).toBeNull();
        });

        it('setting elements to 166', function() {
          expect( second.elements(166) ).toBe(166);
        });
        it('setting pages to 3', function() {
          expect( second.pages(3) ).toBe(3);
        });

      });
    });

    describe('fromHeaders()', function() {
      var getHeader;
      beforeEach(function() {
        getHeader = function(name) {
          var headers = {
            'X-Paginate-Page': 1,
            'X-Paginate-Limit': 10,
            'X-Paginate-Elements': 135,
            'X-Paginate-Pages': 14
          };
          return headers[name];
        };
      });
      it('create without errors', function() {
        expect( function() { PaginationFactory.fromHeaders(getHeader); } ).not.toThrow();
      });

      it('validate invalid page that overflown pages', function() {
        expect( function() { PaginationFactory.fromHeaders(getHeader).page(15); } )
          .toThrow(new TypeError('Value for pagination page is invalid: 15, max page: 14'));
      });

      it('validate invalid page that overflown pages', function() {
        var pag = PaginationFactory.fromHeaders(getHeader);
        pag.page(14);
        expect( pag.hasNext() ).toBe(false);
      });
    });

    describe('createPageCache()', function() {
      var cache;
      beforeEach(function() {
        cache = PaginationFactory.createPageCache(10);
      });

      it('return `undefined` for never loaded page', function() {
        expect(cache.get(1)).toBeUndefined();
      });
    });

  });
});