# A proof-of-concept push notification server
#
# To read more details about the whole process, read the README here:
# https://github.com/highgroove/grocer

require 'sinatra'
require 'grocer'


post '/' do
  puts "Device Token: #{params[:device_token]}"
  puts "Longitude: #{params[:longitude]}"
  puts "Latitude: #{params[:latitude]}"

  pusher = Grocer.pusher(
    certificate: "/Users/kenny/Desktop/certificate.pem",
    gateway:     "gateway.sandbox.push.apple.com"
  )

  notification = Grocer::Notification.new(
    device_token: "8c2889f8ae5166a27158266909684f3879915b9706b48643a72eb0f695be86ea",
    alert:        "Hello from Grocer!"
  )
  pusher.push(notification)
end
