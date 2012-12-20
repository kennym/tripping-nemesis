class LocationTrackerController < UIViewController

  def viewDidLoad
    @locationManager = App.delegate.location_manager
    @locationManager.startMonitoringSignificantLocationChanges
  end

  # iOS >= 4
  def locationManager(manager, didUpdateToLocation:current_location, fromLocation:last_location)
    puts "Location #{current_location} [iOS 5]"
  end

  # iOS >= 6
  def locationManager(manager, didUpdateLocations:locations)
    puts "Location #{locations.last} [iOS 6]"
  end

  def locationManager(manager, didFailWithError:error)
    puts "failed"
  end

end
