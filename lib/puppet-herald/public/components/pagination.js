(function(){
  'use strict';

  var module = angular.module('herald.pagination' , []);

  module.factory('PaginationFactory', function() {
    var KEYS = {
      page: 'X-Paginate-Page',
      limit: 'X-Paginate-Limit',
      elements: 'X-Paginate-Elements',
      pages: 'X-Paginate-Pages'
    };
    function isNotNil(testable) {
      return testable !== null && testable !== undefined;
    }
    function Pagination(page, limit, elements, pages) {
      function isNumeric(input) {
        return !isNaN(input) && input !== '';
      }
      var self = {
        page: parseInt(page),
        limit: parseInt(limit),
        elements: null,
        pages: null,
        listener: null,
        this: this
      };
      if (!isNumeric(page) || self.page < 1) { 
        throw new TypeError('Value for pagination page is invalid: ' + page);
      }
      if (!isNumeric(limit) || self.limit < 1) {
        throw new TypeError('Value for pagination limit is invalid: ' + limit);
      }
      if (isNotNil(elements) && isNumeric(elements)) { self.elements = parseInt(elements); }
      if (isNotNil(pages) && isNumeric(pages)) { self.pages = parseInt(pages); }
      function verifyPage(candidate) {
        var icand = parseInt(candidate);
        if (!isNumeric(candidate) || icand < 1) {
          throw new TypeError('Value for pagination page is invalid: ' + candidate);
        }
        if (isNotNil(self.this.pages()) && icand > self.this.pages()) { 
          throw new TypeError('Value for pagination page is invalid: ' +
              candidate + ', max page: ' + self.this.pages());
        }
        return icand;
      }
      this.page = function(set) {
        if (isNotNil(set)) {
          var candidate = verifyPage(set);
          if (isNotNil(self.listener)) {
            self.listener(candidate);
          }
          self.page = candidate;
        }
        return self.page;
      };
      this.next = function() {
        var actual = this.page();
        this.page(actual + 1);
      };
      this.previous = function() {
        var actual = this.page();
        this.page(actual - 1); 
      };
      this.hasNext = function() {
        return (isNotNil(this.pages()) && this.page()+1 <= this.pages());
      };
      this.hasPrevious = function() {
        return (this.page()-1 >= 1);
      };
      this.limit = function() {
        return self.limit;
      };
      this.elements = function(set) {
        if (isNotNil(set)) {
          self.elements = parseInt(set);
        }
        return self.elements;
      };
      this.pages = function(set) {
        if (isNotNil(set)) {
          self.pages = parseInt(set);
        }
        return self.pages;
      };
      this.toHeaders = function() {
        var headers = {};
        headers[KEYS.page] = this.page() + '';
        headers[KEYS.limit] = this.limit() + '';
        return headers;
      };
      this.setPageChangeListener = function(listener) {
        self.listener = listener;
      };
    }
    var DEFAULT = new Pagination(1, 20);
    return {
      DEFAULT: DEFAULT,
      fromHeaders: function(headersGetter) {
        var page = isNotNil(headersGetter(KEYS.page)) ? headersGetter(KEYS.page) : DEFAULT.page();
        var limit = isNotNil(headersGetter(KEYS.limit)) ? headersGetter(KEYS.limit) : DEFAULT.limit();
        var elements = headersGetter(KEYS.elements);
        var pages = headersGetter(KEYS.pages);
        return new Pagination(page, limit, elements, pages);
      },
      create: function(page, limit) {
        return new Pagination(page, limit);
      }
    };
  });

})();