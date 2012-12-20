class LocationTrackerController < UIViewController

  def viewDidLoad
    @address_field = UITextField.alloc.initWithFrame([[30, 30], [250, 30]])
    @address_field.backgroundColor = UIColor.whiteColor

    @save_button = UIButton.buttonWithType UIButtonTypeRoundedRect
    @save_button.setTitle "Save", forState: UIControlStateNormal
    @save_button.frame = [[100, 100], [100, 50]]
    @save_button.addTarget(self,
                           action: :save_address,
                           forControlEvents: UIControlEventTouchUpInside)

    view.addSubview(@address_field)
    view.addSubview(@save_button)

    @locationManager = App.delegate.location_manager
    @locationManager.startMonitoringSignificantLocationChanges

    true
  end

  def save_address

  end

  # iOS >= 4
  def locationManager(manager, didUpdateToLocation:current_location, fromLocation:last_location)
    puts "Location #{current_location} [iOS 5]"
  end

  # iOS >= 6
  def locationManager(manager, didUpdateLocations:locations)
    puts "Location long: #{locations.last.coordinate.longitude}, lat: #{locations.last.coordinate.latitude} [iOS 6]"

    data = {latitude: locations.last.coordinate.latitude,
            longitude: locations.last.coordinate.longitude}
    BW::HTTP.post("http://localhost:4567/", {payload: data}) do |response|
      if response.ok?
        #json = BW::JSON.parse(response.body.to_str)
        #p json['id']
      else
        App.alert(response.error_message)
      end
    end
  end

  def locationManager(manager, didFailWithError:error)
    puts "failed"
  end

end
