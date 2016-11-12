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
  gulp.src "./app/static/scss/**/*.scss"
    .pipe plumber()
    .pipe sass()
    .pipe concat("app.css")
    .pipe gulp.dest "./public/static"
    .pipe livereload()

# Processes JavaScript files
gulp.task "js", ->
  gulp.src "./app/static/js/**/*.js"
    .pipe plumber()
    .pipe uglify()
    .pipe concat("app.js")
    .pipe gulp.dest "./public/static"
    .pipe livereload()

# Processes images
gulp.task "assets", ->
  gulp.src "./app/assets/**/*"
    .pipe plumber()
    .pipe gulp.dest "./public/static"
    .pipe livereload()

# Processes Pug files
gulp.task "views", ->
  gulp.src "./app/views/**/*.pug"
    .pipe gulp.dest "./public/views"
    .pipe livereload()

# Server routing
gulp.task "server", ->
  app.set "view engine", "pug"
  app.set "views", "./public/views"
  app.use express.static "./public/static"

  app.get "/", (req, res)      -> res.render "index"
  app.get "/about", (req, res) -> res.render "about"

  app.listen 8080

# Watch for file changes
gulp.task "watch", ->
  livereload.listen()
  gulp.watch "./app/static/scss/**/*.scss", ["scss"]
  gulp.watch "./app/static/js/**/*.js",     ["js"]
  gulp.watch "./app/assets/**/*",           ["assets"]
  gulp.watch "./app/views/**/*.pug",        ["views"]

# Runs all gulp tasks
gulp.task "default", ["scss", "js", "assets", "views", "server", "watch"]
