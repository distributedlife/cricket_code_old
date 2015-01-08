find public/javascript -name 'ext' -prune -o -name "*.js" -print0  | xargs -0 node_modules/jshint/bin/hint
