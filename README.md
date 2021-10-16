![MonkeyGTG](https://user-images.githubusercontent.com/59057196/137600343-d6ab9d8d-1296-493c-9134-2f760f4e9fac.png)
# Overview
Monkey invasions in residential areas of NTU are increasingly worrying. MonkeyGTG is an end-to-end solution to the problem of monkey invasion in residential areas of NTU. MonkeyGTG uses advanced deep learning techniques in computer vision for real-time object detection. There are multiple layers to the solution, from embedded device to mobile app and messaging services.

# The Solution
## Embedded device
We use the NVIDIA Jetson Nano Developer Kit as an embedded device with a webcam as an external peripheral. When operating, our object detection algorithm will be invoked on the video feed captured by the webcam in real-time. We aim to detect the presence of monkeys within the vicinity of the residential dormitories. When a monkey is detected, the Jetson Nano will trigger an audio output device to emit ultrasonic waves. According to research, wave frequencies around 30-50kHz will make monkeys uncomfortable and deter them from the area. This is also well above the audible range for humans so it will not be heard.

![setup](https://user-images.githubusercontent.com/59057196/137600344-db32c17a-20b8-4425-847e-e90b255d419d.jpg)

## Mobile App
At the same time, upon detection of monkeys, the Jetson Nano will trigger a push notification to the tenant of the room to alert him/her of the incident.

Using firebase, the mobile app has a feature to indicate the location of recent monkey sightings in residential areas within NTU. Users residing near these areas are encouraged to take extra precaution to close their room windows and secure food items where possible.

![app](https://user-images.githubusercontent.com/59057196/137600341-35c67167-bce5-4e2b-bf5b-814e51dfa1f5.jpg)

## Telegram Bot
With every new monkey sighting, the Jetson Nano will trigger an alert on our self-hosted telegram bot. The alert contains key information such as location of the monkey sighting occuring presently. This alert will be broadcasted to all NTU hall residents who subscribe to the bot. 

![telebot](https://user-images.githubusercontent.com/59057196/137600345-20050ba5-e3c8-4932-bacb-58e44672da1b.jpg)

# Software & Hardware requirements
## System requirements
* Ubuntu 18.04 on NVIDIA Jetson Nano
* Any modern Android/iOS mobile device
* Python 3.6 and above

## Tools/Frameworks
* Pytorch -- 1.9.1 , CUDA --- 10.2
* NVIDIA Jetson Jetpack -- L4T-4.6
* Flutter (Dart)
* Firebase Realtime Database, Firebase Authentication, Firebase Cloud Messaging
* pyTelegramBotAPI
