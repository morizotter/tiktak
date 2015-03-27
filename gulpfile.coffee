gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
sass        = require 'gulp-ruby-sass'
plumber     = require 'gulp-plumber'
concat      = require 'gulp-concat'
haml        = require 'gulp-ruby-haml'
bower       = require 'gulp-bower'
inject      = require 'gulp-inject'
series      = require 'stream-series'
del         = require 'del'
watch       = require 'gulp-watch'
webserver   = require 'gulp-webserver'
runSequence = require 'run-sequence'
ghPages     = require 'gulp-gh-pages'

## SETTINGS

conf =
  src_dir: '_source'
  dist_dir: 'public'
  tmp_dir: '.tmp'

## COMPILE

gulp.task 'haml', ->
  gulp.src "#{conf.src_dir}/app/**/*.haml"
  .pipe haml({ doubleQuote: true })
  .pipe gulp.dest "#{conf.tmp_dir}/"

gulp.task 'coffee', ->
  gulp.src "#{conf.src_dir}/assets/coffee/**/*.coffee"
  .pipe coffee()
  .pipe gulp.dest "#{conf.tmp_dir}/assets/js"

gulp.task 'sass', ->
  sass "#{conf.src_dir}/assets/scss/", {style: 'expanded'}
  .pipe plumber()
  .pipe gulp.dest "#{conf.tmp_dir}/assets/css"

gulp.task "bower", ->
  bower()
  .pipe gulp.dest "#{conf.tmp_dir}/lib"

gulp.task 'inject', ->
  fontAwesome     = gulp.src("#{conf.tmp_dir}/lib/fontawesome/css/font-awesome.css" , {read: false})
  bootstrapCss    = gulp.src("#{conf.tmp_dir}/lib/bootstrap/dist/css/bootstrap.css" , {read: false})
  bootstrapTheme  = gulp.src("#{conf.tmp_dir}/lib/bootstrap/dist/css/bootstrap-theme.css" , {read: false})
  css             = gulp.src("#{conf.tmp_dir}/assets/css/**/*.css" , {read: false})

  jquery          = gulp.src("#{conf.tmp_dir}/lib/jquery/dist/jquery.js" , {read: false})
  bootstrapJs     = gulp.src("#{conf.tmp_dir}/lib/bootstrap/dist/js/bootstrap.js" , {read: false})
  js              = gulp.src("#{conf.tmp_dir}/assets/js/**/*.js" , {read: false})

  gulp.src "#{conf.tmp_dir}/**/*.html"
  .pipe inject(
    series(
      fontAwesome,
      bootstrapCss,
      bootstrapTheme,
      css,
      jquery,
      bootstrapJs,
      js
    ), {relative: true}
  )
  .pipe gulp.dest "#{conf.tmp_dir}/"

## COPY

gulp.task 'copy:dev', ->
  gulp.src ["#{conf.src_dir}/assets/image/**/*"]
  .pipe gulp.dest "#{conf.tmp_dir}/assets/image"

gulp.task 'copy:prod', ->
  gulp.src "#{conf.tmp_dir}/**/*"
  .pipe gulp.dest "#{conf.dist_dir}/"

## CLEAN

gulp.task 'clean', (cb)->
  del ['public'], cb

## SERVE

gulp.task 'webserver', ->
  gulp.src "#{conf.tmp_dir}"
  .pipe(webserver({
    livereload: true
    port: 9001
    fallback: "#{conf.tmp_dir}/index.html"
    open: true
    })
  )

## WATCH

gulp.task 'watch', ->
  gulp.watch [
    "#{conf.src_dir}/**/*"
    ],
    ['build']

## DEPLOY

gulp.task 'gh-pages', ->
  gulp.src 'public/**/*'
  .pipe ghPages()

##################################################
# SERVE
##################################################

gulp.task 'serve', ->
  runSequence(
    'build',
    ['webserver'],
    'watch'
    )

##################################################
# BUILD
##################################################

gulp.task 'compile', ->
   runSequence(
    ['haml','coffee','sass','bower'],
    'inject',
    'copy:dev'
    )

gulp.task 'build', ->
  runSequence(
    ['compile']
    )

##################################################
# DEPLOY
##################################################

gulp.task 'deploy', ->
  runSequence(
    'build',
    'copy:prod',
    'gh-pages'
    )
