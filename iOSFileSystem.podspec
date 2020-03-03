#
# Be sure to run `pod lib lint iOSFileSystem.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSFileSystem'
  s.version          = '1.0.2'
  s.summary          = 'Interact with the iOS file system in a protocol oriented way.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Written in Swift 4.2 the library is based off two main protocols. `Directory` and `File`. You can now build up references to files and directories by conforming to the protocol. 

I provide `Directory` structs for most of the common directories in the sandbox. I also provide a `File` struct for `.png` and `.jpg` files both to serve as an example and to cover you for these two common file types.
                       DESC

  s.homepage         = 'https://github.com/labs-nomad/iOSFileSystem'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shared@nomad-go.com' => 'nomad@shared-go.com' }
  s.source           = { :git => 'https://github.com/labs-nomad/iOSFileSystem.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'iOSFileSystem/**/*.{h,m}'
  s.source_files = 'Sources/iOSFileSystem/**/*.swift'

  s.swift_version = '4.2'
  
  
  # s.resource_bundles = {
  #   'iOSFileSystem' => ['iOSFileSystem/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
