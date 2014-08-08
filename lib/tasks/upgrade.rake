task :upgrade => "environment"
task :upgrade => "db:migrate"
task :upgrade => "assets:precompile"
