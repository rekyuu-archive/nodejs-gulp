gulp        = require 'gulp'
del         = require 'del'
path        = require 'path'
jade        = require 'gulp-jade'
livereload  = require 'gulp-livereload'
plumber     = require 'gulp-plumber'
sass        = require 'gulp-sass'
uglify      = require 'gulp-uglify'
express     = require 'express'
app         = express()

# Cleans the build folder
gulp.task 'clean', (cb) ->
   del ['build'], cb

# Processes SCSS files
gulp.task 'scss', ->
   gulp.src './src/scss/style.scss'
      .pipe plumber()
      .pipe sass()
      .pipe gulp.dest './build/css'
      .pipe livereload()

# Processes JavaScript files
gulp.task 'js', ->
   gulp.src './src/js/**/*.js'
      .pipe plumber()
      .pipe uglify()
      .pipe gulp.dest './build/js'
      .pipe livereload()

# Processes images
gulp.task 'img', ->
   gulp.src './src/img/**/*'
      .pipe plumber()
      .pipe gulp.dest './build/img'
      .pipe livereload()

# Processes Jade files
gulp.task 'html', ->
   gulp.src './src/jade/*.jade'
      .pipe jade()
      .pipe gulp.dest './build'
      .pipe livereload()

# Server routing
gulp.task 'server', ->
   app.use express.static path.join(__dirname, 'build')
   app.listen 8080

# Watch for file changes
gulp.task 'watch', ->
   livereload.listen()
   gulp.watch './src/scss/**/*.scss',  ['scss']
   gulp.watch './src/js/**/*.js',      ['js']
   gulp.watch './src/img/**/*',        ['img']
   gulp.watch './src/jade/**/*.jade',  ['html']

# Runs all gulp tasks
gulp.task 'default', ['scss', 'js', 'img', 'html', 'server', 'watch']