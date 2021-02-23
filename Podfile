source 'https://cdn.cocoapods.org/'

use_frameworks!
inhibit_all_warnings!

project 'MyChat.xcodeproj'

def pods
    
	
  pod 'Moscapsule', :git => 'https://github.com/flightonary/Moscapsule.git'
  pod 'OpenSSL-Universal'
  pod 'KeychainSwift'
pod "Franz"
end

target 'MyChat' do
  platform :ios, '14.0'
  inherit! :search_paths
  pods
end

