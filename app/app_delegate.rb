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

  def applicationDidEnterForeground
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
    action = lambda do
      runLoop = NSRunLoop.currentRunLoop

      data = {latitude: locations.last.coordinate.latitude,
              longitude: locations.last.coordinate.longitude,
              device_token: @device_token }
      BW::HTTP.post("http://192.168.1.100:4567/", {payload: data}) do |response|
        if response.ok?
          #json = BW::JSON.parse(response.body.to_str)
          #p json['id']
        else
          App.alert(response.error_message)
        end
      end

      runLoop.run
    end

    thread = NSThread.alloc.initWithTarget action, selector:"call", object:nil
    thread.start
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
