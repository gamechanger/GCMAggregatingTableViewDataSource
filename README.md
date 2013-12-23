GCMAggregatingTableViewDataSource
==================
[![Build Status](https://travis-ci.org/gamechanger/GCMAggregatingTableViewDataSource.png)](https://travis-ci.org/gamechanger/GCMAggregatingTableViewDataSource)

A template project for creating public GCM* projects

* Rename the project, targets, and folders
  * [How to duplicate a project](http://stackoverflow.com/questions/17744319/duplicate-and-rename-xcode-project-associated-folders)
  * Update script/template.podspec.erb
  * Regenerate GCMAggregatingTableViewDataSource.podspec. `ruby script/generate-podspec.rb 0.1.0 > GCMAggregatingTableViewDataSource.podspec`
  * Rename GCMAggregatingTableViewDataSource.podspec to match the name of your new repository.
  * Update the Podfile to use the up-to-date project and target names.
  * Pick a gemset name (it should be unique) and update it in .ruby-gemset.
  * Change the names in the Rakefile
* Configure Travis CI 
  * [Register the project with Travis CI.](http://about.travis-ci.org/docs/user/getting-started/)
  * Configure hipchat notifications with our encrypted API key by following the instructions [here](http://about.travis-ci.org/docs/user/notifications/#HipChat-notification).
  * Update the build status image at the top of README.md (this file).
* Configure gcbot to handle pull requests
  * edit scripts/gc-github-global-watcher.coffee
  * create a github service hook that's pull request-aware: `curl -u <your github username> --data @script/webhook.json https://api.github.com/repos/gamechanger/<project name>/hooks`
