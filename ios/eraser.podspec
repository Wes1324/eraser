#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint eraser.podspec' to validate before publishing.
#
# The Swift sources live in the Swift package (eraser/Sources/eraser) so that the
# plugin can be consumed either through Swift Package Manager or CocoaPods.
#
Pod::Spec.new do |s|
  s.name             = 'eraser'
  s.version          = '0.0.1'
  s.summary          = 'Dismiss notifications and reset the iOS badge count programmatically.'
  s.description      = <<-DESC
A Flutter plugin that allows notifications and iOS badge counts to be dismissed programmatically.
                       DESC
  s.homepage         = 'https://github.com/Wes1324/eraser'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Wes1324' => 'https://github.com/Wes1324' }
  s.source           = { :path => '.' }
  s.source_files = 'eraser/Sources/eraser/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
