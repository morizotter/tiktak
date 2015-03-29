(function() {
  var searchDirective;

  searchDirective = function() {
    return {
      templateUrl: "angular/directives/search/searchDirective.html",
      scope: {},
      controller: ['$scope', '$interval', function($scope, $interval) {}],
      controllerAs: "clockCtrl"
    };
  };

  angular.module('app').directive('search', [searchDirective]);

}).call(this);
