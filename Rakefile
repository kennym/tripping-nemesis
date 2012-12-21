# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'location-sender'
  app.frameworks += ["CoreLocation", "CoreData"]
  app.provisioning_profile = "/Users/kenny/Library/MobileDevice/Provisioning/locationsender.mobileprovision"
  app.entitlements['aps-environment'] = 'development'
  app.entitlements['get-task-allow'] = true
  app.info_plist['UIBackgroundModes'] = ['location'] 
end
