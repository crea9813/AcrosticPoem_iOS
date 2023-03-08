# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


def rx_swift
    pod 'RxSwift', '6.5.0'
end

def rx_cocoa
    pod 'RxCocoa', '6.5.0'
end

target 'Data' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Data
  rx_swift
  
  pod 'Moya'
  pod 'Moya/RxSwift'
end

target 'Domain' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Domain
  rx_swift
end

target 'AcrosticPoem_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AcrosticPoem_ios

  rx_cocoa
  rx_swift
  
  pod 'Then'
  pod 'Shuffle-iOS'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'Google-Mobile-Ads-SDK'
  
end
