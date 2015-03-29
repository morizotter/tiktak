clockDirective = ->
  templateUrl: "angular/directives/clock/clockDirective.html"
  controller: ['$scope', ($scope) ->
    @currentTime = ->
      date = new Date()
      hours = date.getHours()
      minutes = date.getMinutes()
      seconds = date.getSeconds()
      "#{hours} : #{minutes} . #{seconds}"

    @text = "controller"
  ]
  link: (scope, element, attrs, ctrl) ->
    scope.text = "test"
    scope.time = ctrl.currentTime()

angular.module('app')
.directive 'clock', [clockDirective]
