class AppDelegate

  attr_accessor :location_manager

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @controller = LocationTrackerController.alloc.init
    @window.rootViewController = @controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

  def applicationDidEnterBackground
    @locationManager.startMonitoringSignificantLocationChanges
  end

  def applicationDidEnterForeground
  end

  def location_manager
    if @locationManager.nil?
      @locationManager = CLLocationManager.alloc.init
      @locationManager.setDesiredAccuracy(KCLLocationAccuracyBest)
      @locationManager.delegate = @controller
    end
    @locationManager
  end

end
