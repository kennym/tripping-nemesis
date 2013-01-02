class LocationTrackerController < UIViewController
  attr_accessor :url

  def viewDidLoad
    @address_field = UITextField.alloc.initWithFrame([[30, 30], [250, 30]])
    @address_field.backgroundColor = UIColor.whiteColor
    @address_field.text = "http://192.168.1.127:4567"

    view.addSubview(@address_field)

    @locationManager = App.delegate.location_manager

    true
  end

  def url
    @address_field.text
  end
end
