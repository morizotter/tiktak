clockDirective = ->
  templateUrl: "angular/directives/clock/clockDirective.html"
  scope:
    time: "@"
    text: "@"
  controller: ['$scope', '$interval', ($scope, $interval) ->
    $scope.time = "--:--:--"
    $scope.text = "Tokyo"
    @updateClock = ->
      date = new Date()
      hours = date.getHours()
      minutes = date.getMinutes()
      seconds = date.getSeconds()
      $scope.time = "#{hours} : #{minutes} . #{seconds}"

    $interval(@updateClock, 1000)
  ]
  controllerAs: "clockCtrl"

angular.module('app')
.directive 'clock', [clockDirective]
