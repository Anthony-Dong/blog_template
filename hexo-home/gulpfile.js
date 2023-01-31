var gulp = require('gulp')
var minifycss = require('gulp-clean-css');
const uglify = require('gulp-uglify-es').default;
const htmlmin = require('gulp-html-minifier-terser');

gulp.task('compress_css', function () {
    return gulp.src('./public/**/*.css')
        .pipe(minifycss({ compatibility: 'ie8' })) // 兼容到IE8
        .pipe(gulp.dest('./public'));
});

gulp.task('compress_js', function () {
    return gulp.src('./public/**/*.js')
        .pipe(uglify())
        .pipe(gulp.dest('./public'))
})

// 注意报错可以排出目录！
// 可接受参数的文档：https://github.com/terser/html-minifier-terser#options-quick-reference
gulp.task('compress_html', function () {
    return gulp.src(['./public/**/*.html', '!./public/2022/03/27/583186f06a088dc9967a483e3876b2a2/index.html'])
        .pipe(htmlmin(
            {
                removeComments: true, // 移除注释
                removeEmptyAttributes: true, // 移除值为空的参数
                removeRedundantAttributes: true, // 移除值跟默认值匹配的属性
                collapseBooleanAttributes: true, // 省略布尔属性的值
                collapseWhitespace: true, // 移除空格和空行                
                minifyJS: true, // 压缩HTML中的JS
                minifyCSS: true, // 压缩HTML中的CSS
                minifyURLs: true, // 压缩HTML中的链接
            }
        ))
        .pipe(gulp.dest('./public'))
})


// 默认任务，不带任务名运行gulp时执行的任务
gulp.task('default', gulp.parallel(
    'compress_css', 'compress_js', 'compress_html'
));