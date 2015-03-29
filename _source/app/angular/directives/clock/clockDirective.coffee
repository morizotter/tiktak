clockDirective = ->
  templateUrl: "angular/directives/clock/clockDirective.html"
  scope:
    time: "@"
    text: "@"
  controller: ['$scope', '$interval', ($scope, $interval) ->
    $scope.time = "--:--:--"
    @updateClock = ->
      date = new Date()
      hours = date.getHours()
      minutes = date.getMinutes()
      seconds = date.getSeconds()
      $scope.time = "#{hours} : #{minutes} . #{seconds}"

    $scope.text = "controller"

    $interval(@updateClock, 1000)
  ]
  controllerAs: "clockCtrl"
  link: (scope, element, attrs, ctrl) ->
    # scope.text = ctrl.text
    # scope.time = ctrl.time

angular.module('app')
.directive 'clock', [clockDirective]
