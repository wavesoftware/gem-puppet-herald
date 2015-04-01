(function(angular){
  'use strict';

  var module = angular.module('herald.pagination' , []);

  module.factory('PaginationFactory', function() {
    var KEYS = {
      page: 'X-Paginate-Page',
      limit: 'X-Paginate-Limit',
      elements: 'X-Paginate-Elements',
      pages: 'X-Paginate-Pages'
    }
    function Pagination(page, limit, elements, pages) {
      function isNumeric(input) {
        return (input - 0) == input && (''+input).trim().length > 0;
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
      if (elements != null && isNumeric(elements)) { self.elements = parseInt(elements); }
      if (pages != null && isNumeric(pages)) { self.pages = parseInt(pages); }
      function verifyPage(candidate) {
        var icand = parseInt(candidate);
        if (!isNumeric(candidate) || icand < 1) {
          throw new TypeError('Value for pagination page is invalid: ' + candidate);
        }
        if (self.this.pages() != null && icand > self.this.pages()) { 
          throw new TypeError('Value for pagination page is invalid: ' +
              candidate + ', max page: ' + self.this.pages());
        }
        return icand;
      }
      this.page = function(set) {
        if (set != null) {
          var candidate = verifyPage(set);
          if (self.listener != null) {
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
        return (this.pages() != null && this.page()+1 <= this.pages());
      };
      this.hasPrevious = function() {
        return (this.page()-1 >= 1);
      };
      this.limit = function() {
        return self.limit;
      };
      this.elements = function(set) {
        if (set != null) {
          self.elements = parseInt(set);
        }
        return self.elements;
      };
      this.pages = function(set) {
        if (set != null) {
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
    var DEFAULT = new Pagination(1, 5);
    return {
      DEFAULT: DEFAULT,
      fromHeaders: function(headersGetter) {
        var page = headersGetter(KEYS.page) != null ? headersGetter(KEYS.page) : DEFAULT.page();
        var limit = headersGetter(KEYS.limit) != null ? headersGetter(KEYS.limit) : DEFAULT.limit();
        var elements = headersGetter(KEYS.elements);
        var pages = headersGetter(KEYS.pages);
        return new Pagination(page, limit, elements, pages);
      },
      create: function(page, limit) {
        return new Pagination(page, limit);
      }
    };
  });

})(angular);