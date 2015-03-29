clockDirective = ->
  templateUrl: "clockDirective.html"
  link: (scope, element) ->
    scope.text = "text"

angular.module('app')
.directive 'clock', [clockDirective]
