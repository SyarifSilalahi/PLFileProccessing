#
# Be sure to run `pod lib lint PLFileProccessing.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PLFileProccessing"
  s.version          = "0.1.0"
  s.summary          = "Function to proccess upload and download file, especially for image file"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "This CocoaPod provides the ability to upload file to server url or for downloading file from server url"

  s.homepage         = "https://github.com/SyarifSilalahi/PLFileProccessing"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Syarif Silalahi" => "syarif@pistarlabs.com" }
  s.source           = { :git => "https://github.com/SyarifSilalahi/PLFileProccessing.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/lekrip'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PLFileProccessing' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'Alamofire', '~> 2.0'
   s.dependency 'KVNProgress'

end
