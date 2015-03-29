(function() {
  var clockDirective;

  clockDirective = function() {
    return {
      templateUrl: "clockDirective.html",
      link: function(scope, element) {
        return scope.text = "text";
      }
    };
  };

  angular.module('app').directive('clock', [clockDirective]);

}).call(this);
