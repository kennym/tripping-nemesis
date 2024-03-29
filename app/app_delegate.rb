class AppDelegate

  attr_accessor :location_manager
  attr_accessor :device_token

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @controller = LocationTrackerController.alloc.init
    @window.rootViewController = @controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)

    true
  end

  def applicationDidEnterBackground(application)
    @locationManager.startMonitoringSignificantLocationChanges
  end

  def applicationDidBecomeActive
    @locationManager.stopMonitoringSignificantLocationChanges
  end

  def application(application, didReceiveRemoteNotification:userInfo)

  end

  def application(app, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    @device_token = deviceToken.description.gsub(" ", "").gsub("<", "").gsub(">", "")

    # Log the push notification to the console
    puts @device_token
  end

  def application(app, didFailToRegisterForRemoteNotificationsWithError:error)
    show_alert "Error when registering for device token", "Error, #{error}"
  end

  def device_token
    @device_token
  end

  def location_manager
    if @locationManager.nil?
      @locationManager = CLLocationManager.alloc.init
      @locationManager.setDesiredAccuracy(KCLLocationAccuracyBest)
      @locationManager.delegate = self
    end
    @locationManager
  end

  # iOS >= 4
  def locationManager(manager, didUpdateToLocation:current_location, fromLocation:last_location)
    puts "Location #{current_location} [iOS 5]"
  end

  # iOS >= 6
  def locationManager(manager, didUpdateLocations:locations)
    if App.shared.applicationState == UIApplicationStateBackground
      bgTask = App.shared.beginBackgroundTaskWithExpirationHandler(lambda {UIApp.shared.endBackgroundTask(bgTask) })

      data = {latitude: locations.last.coordinate.latitude,
              longitude: locations.last.coordinate.longitude,
              device_token: @device_token }

      data_str = "latitude=#{data[:latitude]}&longitude=#{data[:longitude]}&device_token=#{@device_token}"

      url_string = ("#{@controller.url}").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
      url = NSURL.URLWithString(url_string)
      request = NSMutableURLRequest.requestWithURL(url)
      request.setHTTPMethod("POST")
      request.setHTTPBody(data_str.to_s.dataUsingEncoding(NSUTF8StringEncoding))

      response = nil
      error = nil
      data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
      raise "BOOM!" unless (error.nil?)
      json = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)

      if bgTask != UIBackgroundTaskInvalid
        App.shared.endBackgroundTask(bgTask)
        bgTask = UIBackgroundTaskInvalid
      end
    end
  end

  def locationManager(manager, didFailWithError:error)
    puts "failed"
  end

  def show_alert(title, message)
    alert = UIAlertView.new
    alert.title = title
    alert.message = message
    alert.show
  end
end
