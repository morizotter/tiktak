(function() {
  angular.module('app', []).controller('TodoController', [
    '$scope', function($scope) {
      $scope.todos = [
        {
          text: 'learn angular',
          done: false
        }, {
          text: 'build an angular app',
          done: false
        }
      ];
      $scope.addTodo = function() {
        $scope.todos.push({
          text: $scope.todoText,
          done: false
        });
        return $scope.todoText = '';
      };
      $scope.remaining = function() {
        var count;
        count = 0;
        angular.forEach($scope.todos, function(todo) {
          var ref;
          return count += (ref = todo.done) != null ? ref : {
            0: 1
          };
        });
        return count;
      };
      return $scope.archive = function() {
        var oldTodos;
        oldTodos = $scope.todos;
        $scope.todos = [];
        return angular.forEach(oldTodos, function(todo) {
          if (!todo.done) {
            return $scope.todos.push(todo);
          }
        });
      };
    }
  ]);

}).call(this);
