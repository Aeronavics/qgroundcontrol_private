

# Log Synchronization

Aeronavics QGC is able to connect to a Nexus repository to synchronize each customer logs.
For that the customer will have to enter the proper login information in Aeronavics QGC setup menu :

![image](https://user-images.githubusercontent.com/6662416/70399465-1f86ef80-1a89-11ea-868a-5d411956c831.png)

The field "Network Id" is the id given to a customer/user so that logs can be synchronized.

The synchronization will only work when internet is accessible.
Logs will be store in /Documents/Aeronavics_QGC on the computer and will be synchronized the next time Aeronavics QGC is started with internet accessible.

Those logs will be accessible in [here](https://services.aeronavics.com/nexus/#browse/browse:flight_logs_raw). Each subfolder will be named by networkid and the name format of each log file is :
SerialNumber_Date.tlog.

# Add user for log synchronization:

This is the procedure to add a new network id to Nexus 

## 1. Create a new Content Selectors 

The content selector allow us to restrict access of a particular part of an artifact repository (that match a regexp) :
![content_selector](https://user-images.githubusercontent.com/6662416/67992075-4be86880-fca0-11e9-862c-877b533aefcd.png)

## 2. Create a privilege as follow (Repository Content Selector)

![privilege](https://user-images.githubusercontent.com/6662416/67992077-4d199580-fca0-11e9-9a2b-55a76ccb6c86.png)

## 3. Create a role as follow

![role](https://user-images.githubusercontent.com/6662416/67992083-4db22c00-fca0-11e9-9f3f-d1326f22ce37.png)

## 4. Create a user
Set password = username.

![user](https://user-images.githubusercontent.com/6662416/67992087-4f7bef80-fca0-11e9-9921-91fb4ed68ada.png)
