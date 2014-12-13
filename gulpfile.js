/**
 * Created by romab_000 on 12/13/2014.
 */
var gulp = require('gulp'),
    coffee = require('gulp-coffee');

gulp.task('coffee', function() {
    gulp.src('app/**/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('build'))
});

gulp.task('watch', function() {
    gulp.watch('app/**/*.coffee', ['coffee'])
})

gulp.task('default', ['coffee', 'watch']);