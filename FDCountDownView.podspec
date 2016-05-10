#
# Be sure to run `pod lib lint FDCountDownView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FDCountDownView"
  s.version          = "0.1.0"
  s.summary          = "A View to display a circle, using in advertisement view to jump the waiting time."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
In many apps, An advertisement view will be present when the apps was launched. And, a common practice is that adding a "Jump" button to overleap the waiting time. The FDCountDownView will be a good choice for the "Jump" button.
DESC

  s.homepage         = "https://github.com/liuwin7/FDCountDownView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "liuwin7" => "liuwin7@163.com" }
  s.source           = { :git => "https://github.com/liuwin7/FDCountDownView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FDCountDownView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FDCountDownView' => ['FDCountDownView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
