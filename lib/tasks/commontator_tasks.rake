COPY_TASKS = ['assets/images', 'assets/stylesheets', 'views', 'mailers', 'helpers', 'controllers', 'models']

namespace :commontator do
  namespace :install do
    desc "Copy initializers from commontator to application"
    task :initializers do
      Dir.glob(File.expand_path('../../../config/initializers/*.rb', __FILE__)) do |file|
        if File.exists?(File.expand_path(File.basename(file), 'config/initializers'))
          print "NOTE: Initializer #{File.basename(file)} from commontator has been skipped. Initializer with the same name already exists.\n"
        else
          cp file, 'config/initializers', :verbose => false
          print "Copied initializer #{File.basename(file)} from commontator\n"
        end
      end
    end
  end
  
  namespace :copy do
    COPY_TASKS.each do |path|
      name = File.basename(path)
      desc "Copy #{name} from commontator to application"
      task name.to_sym do
        cp_r File.expand_path("../../../app/#{path}/commontator", __FILE__), "app/#{path}", :verbose => false
        print "Copied #{name} from commontator\n"
      end
    end
  end
  
  desc "Copy initializers and migrations from commontator to application"
  task :install do
    Rake::Task["commontator:install:initializers"].invoke
    Rake::Task["commontator:install:migrations"].invoke
  end
  
  desc "Copy assets, views, mailers, helpers, controllers and models from commontator to application"
  task :copy do
    COPY_TASKS.each do |path|
      Rake::Task["commontator:copy:#{File.basename(path)}"].invoke
    end
  end
end

