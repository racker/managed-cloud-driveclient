default[:jungledisk][:driveclient][:bootstrapfile] = "/etc/jungledisk/bootstrap.json"
default[:jungledisk][:driveclient][:sleep] = 10

set_unless[:jungledisk][:driveclient][:apihostname] = "controlpanelsvc.drivesrvr.com"
set_unless[:jungledisk][:driveclient][:username] = "username"
set_unless[:jungledisk][:driveclient][:password] = "password"
