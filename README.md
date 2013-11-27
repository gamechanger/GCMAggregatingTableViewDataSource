GCMTemplateProject
==================

A template project for creating public GCM* projects

* Rename the project, targets, and folders
  * [How to duplicate a project](http://stackoverflow.com/questions/17744319/duplicate-and-rename-xcode-project-associated-folders)
  * Update script/template.podspec.erb
  * Regenerate GCMTemplateProject.podspec. ruby script/generate-podspec.rb 0.1.0 > GCMTemplateProject.podspec
  * Rename GCMTemplateProject.podspec to match the name of your new repository.
  * Update the Podfile to use the up-to-date project and target names.
  * Pick a gemset name (it should be unique) and update it in .ruby-gemset.
  * Change the names in the Rakefile
* Register the project with Travis CI.
* Configure hipchat notifications with our encrypted API key by following the instructions [here](http://about.travis-ci.org/docs/user/notifications/#HipChat-notification).