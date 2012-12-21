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

    true
  end

  def save_address

  end

end
