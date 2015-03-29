(function() {
  var clockDirective;

  clockDirective = function() {
    return {
      templateUrl: "angular/directives/clock/clockDirective.html",
      scope: {
        time: "@",
        text: "@"
      },
      controller: [
        '$scope', '$interval', function($scope, $interval) {
          $scope.time = "--:--:--";
          $scope.text = "Tokyo";
          this.updateClock = function() {
            var date, hours, minutes, seconds;
            date = new Date();
            hours = date.getHours();
            minutes = date.getMinutes();
            seconds = date.getSeconds();
            return $scope.time = hours + " : " + minutes + " . " + seconds;
          };
          return $interval(this.updateClock, 1000);
        }
      ],
      controllerAs: "clockCtrl"
    };
  };

  angular.module('app').directive('clock', [clockDirective]);

}).call(this);
