gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
compass     = require 'gulp-compass'
concat      = require 'gulp-concat'
haml        = require 'gulp-ruby-haml'
del         = require 'del'
watch       = require 'gulp-watch'
webserver   = require 'gulp-webserver'
runSequence = require 'run-sequence'
ghPages     = require 'gulp-gh-pages'

dir =
  src: '_source'
  dist: 'public'

gulp.task 'coffee', ->
  gulp.src "#{dir.src}/coffee/**/*.coffee"
  .pipe coffee()
  .pipe gulp.dest "#{dir.dist}/assets/js"

gulp.task 'compass', ->
  gulp.src "#{dir.src}/scss/**/*.scss"
  .pipe compass({
    config_file: 'config.rb'
    sass: "#{dir.src}/scss/"
    css: "#{dir.src}/css/"
  })

gulp.task 'haml', ->
  gulp.src "#{dir.src}/app/**/*.haml"
  .pipe haml({ doubleQuote: true })
  .pipe gulp.dest "#{dir.dist}"

gulp.task 'copy', ->
  gulp.src ["#{dir.src}/image/**/*"]
  .pipe gulp.dest "#{dir.dist}/assets/image"
  gulp.src ["#{dir.src}/css/**/*"]
  .pipe gulp.dest "#{dir.dist}/assets/css"
  gulp.src ["#{dir.src}/js/**/*"]
  .pipe gulp.dest "#{dir.dist}/assets/js"
  gulp.src ["#{dir.src}/fonts/**/*"]
  .pipe gulp.dest "#{dir.dist}/assets/fonts"

gulp.task 'clean', (cb)->
  del ['public'], cb

gulp.task 'webserver', ->
  gulp.src "#{dir.dist}"
  .pipe(webserver({
    livereload: true
    port: 9000
    fallback: "#{dir.dist}/index.html"
    open: true
    })
  )

gulp.task 'watch', ->
  gulp.watch [
    "#{dir.src}/**/*"
    ],
    ['build']

##################################################
# SERVE
##################################################

gulp.task 'serve', ->
  runSequence(
    ['build'],
    ['webserver'],
    'watch'
    )

##################################################
# BUILD
##################################################

gulp.task 'compile', ->
   runSequence(
    ['haml','coffee','compass'],
    'copy'
    )

gulp.task 'build', ['clean'], ->
  runSequence(
    ['compile']
    )

##################################################
# DEPLOY
##################################################

gulp.task 'deploy', ->
  gulp.src 'public/**/*'
  .pipe ghPages()
