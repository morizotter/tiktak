gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
sass        = require 'gulp-sass'
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
  dist_dir: '_public'
  tmp_dir: '.tmp'

## COMPILE

gulp.task 'haml', ->
  gulp.src "#{conf.src_dir}/app/**/*.haml"
  .pipe haml({ doubleQuote: true })
  .pipe gulp.dest "#{conf.tmp_dir}/"

gulp.task 'coffee', ->
  gulp.src "#{conf.src_dir}/app/**/*.coffee"
    .pipe coffee()
    .pipe gulp.dest "#{conf.tmp_dir}/"
  gulp.src "#{conf.src_dir}/assets/coffee/**/*.coffee"
  .pipe coffee()
  .pipe gulp.dest "#{conf.tmp_dir}/assets/js"

gulp.task 'sass', ->
  gulp.src "#{conf.src_dir}/assets/scss/**/*.scss"
  .pipe sass()
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
  underscore      = gulp.src("#{conf.tmp_dir}/lib/underscore/underscore.js" , {read: false})
  angularJs       = gulp.src("#{conf.tmp_dir}/lib/angular/angular.js" , {read: false})
  bootstrapJs     = gulp.src("#{conf.tmp_dir}/lib/bootstrap/dist/js/bootstrap.js" , {read: false})
  myAngular       = gulp.src("#{conf.tmp_dir}/angular/**/*.js" , {read: false})
  myJs            = gulp.src("#{conf.tmp_dir}/assets/js/**/*.js" , {read: false})

  gulp.src "#{conf.tmp_dir}/**/*.html"
  .pipe inject(
    series(
      fontAwesome,
      bootstrapCss,
      bootstrapTheme,
      css,
      jquery,
      underscore,
      angularJs,
      bootstrapJs,
      myAngular,
      myJs
    ), {relative: true}
  )
  .pipe gulp.dest "#{conf.tmp_dir}/"

gulp.task 'del:tmp', ->
  del.sync ["#{conf.tmp_dir}/**/*"]

gulp.task 'del:dist', ->
  del.sync ["#{conf.dist_dir}/**/"]

## COPY

gulp.task 'copy:dev', ->
  gulp.src ["#{conf.src_dir}/assets/image/**/*"]
  .pipe gulp.dest "#{conf.tmp_dir}/assets/image"

gulp.task 'copy:dist', ->
  gulp.src "#{conf.tmp_dir}/**/*"
  .pipe gulp.dest "#{conf.dist_dir}/"

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
  gulp.src "#{conf.dist_dir}/**/*"
  .pipe ghPages()

##################################################
# SERVE
##################################################

gulp.task 'serve', ['build'], ->
  runSequence(
    # ['build'],
    ['webserver'],
    ['watch']
    )

##################################################
# BUILD
##################################################

gulp.task 'build', (cb) ->
   runSequence(
    ['del:tmp'],
    ['haml','coffee','sass','bower'],
    ['inject'],
    ['copy:dev'],
    cb
    )

##################################################
# DEPLOY
##################################################

gulp.task 'deploy', ['build'], ->
  runSequence(
    ['del:dist'],
    ['copy:dist'],
    'gh-pages',
    'del:dist'
    )
