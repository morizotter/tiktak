MainController = ($scope) ->
  $scope.todos = [
    {text: 'learn angular', done:false},
    {text: 'build an angular app', done:false}
  ]

  $scope.addTodo = ->
    $scope.todos.push {text:$scope.todoText, done:false}
    $scope.todoText = ''

  $scope.remaining = ->
    count = 0
    angular.forEach $scope.todos, (todo) ->
      count += todo.done ? 0 : 1
    count

  $scope.archive = ->
    oldTodos = $scope.todos
    $scope.todos = []
    angular.forEach oldTodos, (todo) ->
      if !todo.done
        $scope.todos.push todo

angular.module 'app'
.controller 'MainController', ['$scope', MainController]
