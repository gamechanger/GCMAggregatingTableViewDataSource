namespace :debug do
  task :clean do |t|
    sh "xctool -workspace GCMTemplateProject.xcworkspace -scheme GCMTemplateProject -sdk iphonesimulator clean"
  end
  task :cleanbuild do |t|
    sh "xctool -workspace GCMTemplateProject.xcworkspace -scheme GCMTemplateProject -sdk iphonesimulator clean build"
  end
  task :build do |t|
    sh "xctool -workspace GCMTemplateProject.xcworkspace -scheme GCMTemplateProject -sdk iphonesimulator build"
  end
end

namespace :test do
  task :default do |t|
    sh "xctool -workspace GCMTemplateProject.xcworkspace -scheme GCMTemplateProject -sdk iphonesimulator -reporter plain test -freshInstall -freshSimulator"
  end

  task :ci => ["debug:cleanbuild", "test:default"]
end

task :analyze do
  sh "xctool -workspace GCMTemplateProject.xcworkspace -scheme GCMTemplateProject analyze"
end

task :test => "test:default"

