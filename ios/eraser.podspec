#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint eraser.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'eraser'
  s.version          = '3.1.0'
  s.summary          = 'Dismiss remote push notifications and reset the iOS badge count.'
  s.description      = <<-DESC
A flutter plugin that allows remote push notifications to be dismissed and the iOS badge count to be reset.
                       DESC
  s.homepage         = 'https://github.com/Wes1324/eraser'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Wesley Coffin-Jones' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'eraser/Sources/eraser/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
