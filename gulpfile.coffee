gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
sass        = require 'gulp-ruby-sass'
concat      = require 'gulp-concat'
haml        = require 'gulp-ruby-haml'
bower       = require 'gulp-bower'
inject      = require 'gulp-inject'
del         = require 'del'
watch       = require 'gulp-watch'
webserver   = require 'gulp-webserver'
runSequence = require 'run-sequence'
ghPages     = require 'gulp-gh-pages'

conf =
  src_dir: '_source'
  dist_dir: 'public'

gulp.task 'coffee', ->
  gulp.src "#{conf.src_dir}/assets/coffee/**/*.coffee"
  .pipe coffee()
  .pipe gulp.dest "#{conf.dist_dir}/assets/js"

gulp.task 'sass', ->
  sass "#{conf.src_dir}/assets/scss/"
  .pipe gulp.dest "#{conf.dist_dir}/assets/css"

gulp.task 'haml', ->
  gulp.src "#{conf.src_dir}/app/**/*.haml"
  .pipe haml({ doubleQuote: true })
  .pipe gulp.dest "#{conf.dist_dir}/assets/html"

gulp.task "bower", ->
  bower()
  .pipe gulp.dest "#{conf.dist_dir}/lib"

gulp.task 'copy', ->
  gulp.src ["#{conf.src_dir}/assets/image/**/*"]
  .pipe gulp.dest "#{conf.dist_dir}/assets/image"
  gulp.src ["#{conf.src_dir}/assets/css/**/*"]
  .pipe gulp.dest "#{conf.dist_dir}/assets/css"
  gulp.src ["#{conf.src_dir}/assets/js/**/*"]
  .pipe gulp.dest "#{conf.dist_dir}/assets/js"
  gulp.src ["#{conf.src_dir}/assets/fonts/**/*"]
  .pipe gulp.dest "#{conf.dist_dir}/assets/fonts"

gulp.task 'inject', ->
  gulp.src "#{conf.dist_dir}/assets/html/**/*.html"
  .pipe inject(gulp.src("#{conf.dist_dir}/assets/css/**/*.css" , {read: false}), {relative: true})
  .pipe inject(gulp.src("#{conf.dist_dir}/assets/js/**/*.js" , {read: false}), {relative: true})
  .pipe gulp.dest "#{conf.dist_dir}/"

gulp.task 'clean', (cb)->
  del ['public'], cb

gulp.task 'webserver', ->
  gulp.src "#{conf.dist_dir}"
  .pipe(webserver({
    livereload: true
    port: 9001
    fallback: "#{conf.dist_dir}/index.html"
    open: true
    })
  )

gulp.task 'watch', ->
  gulp.watch [
    "#{conf.src_dir}/assets/**/*"
    ],
    ['build']

##################################################
# SERVE
##################################################

gulp.task 'serve', ->
  runSequence(
    ['webserver'],
    'watch'
    )

##################################################
# BUILD
##################################################

gulp.task 'compile', ->
   runSequence(
    ['haml','coffee','sass','bower'],
    'copy',
    'inject'
    )

gulp.task 'build', ->
  runSequence(
    ['compile']
    )

##################################################
# DEPLOY
##################################################

gulp.task 'deploy', ->
  gulp.src 'public/**/*'
  .pipe ghPages()
