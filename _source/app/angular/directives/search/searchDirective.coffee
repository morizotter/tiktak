searchDirective = ->
  templateUrl: "angular/directives/search/searchDirective.html"
  scope:{}
  controller: ['$scope', '$interval', ($scope, $interval) ->

  ]
  controllerAs: "clockCtrl"

angular.module('app')
.directive 'search', [searchDirective]
