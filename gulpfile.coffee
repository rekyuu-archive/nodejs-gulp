gulp        = require "gulp"
concat      = require "gulp-concat"
del         = require "del"
path        = require "path"
pug         = require "gulp-pug"
livereload  = require "gulp-livereload"
plumber     = require "gulp-plumber"
sass        = require "gulp-sass"
uglify      = require "gulp-uglify"
express     = require "express"
app         = express()

# Cleans the public folder
gulp.task "clean", (cb) ->
  del ["public"], cb

# Processes SCSS files
gulp.task "scss", ->
  gulp.src "./app/scss/**/*.scss"
    .pipe plumber()
    .pipe sass()
    .pipe concat("app.css")
    .pipe gulp.dest "./public/static"
    .pipe livereload()

# Processes JavaScript files
gulp.task "js", ->
  gulp.src "./app/js/**/*.js"
    .pipe plumber()
    .pipe uglify()
    .pipe concat("app.js")
    .pipe gulp.dest "./public/static"
    .pipe livereload()

# Processes images
gulp.task "img", ->
  gulp.src "./app/img/**/*"
    .pipe plumber()
    .pipe gulp.dest "./public/static/img"
    .pipe livereload()

# Processes Pug files
gulp.task "html", ->
  gulp.src "./app/pug/**/*.pug"
    .pipe gulp.dest "./public/views"
    .pipe livereload()

# Server routing
gulp.task "server", ->
  app.set 'view engine', 'pug'
  app.set 'views', './public/views'
  app.use express.static './public/static'

  app.get '/', (req, res) -> res.render 'index'

  app.listen 8080

# Watch for file changes
gulp.task "watch", ->
  livereload.listen()
  gulp.watch "./app/scss/**/*.scss",  ["scss"]
  gulp.watch "./app/js/**/*.js",      ["js"]
  gulp.watch "./app/img/**/*",        ["img"]
  gulp.watch "./app/pug/**/*.pug",    ["html"]

# Runs all gulp tasks
gulp.task "default", ["scss", "js", "img", "html", "server", "watch"]
