(function() {
  var clockDirective;

  clockDirective = function() {
    return {
      templateUrl: "angular/directives/clock/clockDirective.html",
      controller: [
        '$scope', function($scope) {
          this.currentTime = function() {
            var date, hours, minutes, seconds;
            date = new Date();
            hours = date.getHours();
            minutes = date.getMinutes();
            seconds = date.getSeconds();
            return hours + " : " + minutes + " . " + seconds;
          };
          return this.text = "controller";
        }
      ],
      link: function(scope, element, attrs, ctrl) {
        scope.text = "test";
        return scope.time = ctrl.currentTime();
      }
    };
  };

  angular.module('app').directive('clock', [clockDirective]);

}).call(this);
