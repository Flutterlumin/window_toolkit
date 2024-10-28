#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint window_manager.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
    s.name             = 'window_toolkit'
    s.version          = '0.0.1'
    s.summary          = 'A new flutter plugin project.'
    s.description      = <<-DESC
  A new flutter plugin project.
                         DESC
    s.homepage         = 'https://github.com/Flutterlumin/'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'mesalih' => 'mhmesalih@gmail.com' }
    s.source           = { :path => '.' }
    s.source_files     = 'Classes/**/*'
    s.dependency 'FlutterMacOS'
  
    s.platform = :osx, '10.14'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
    s.swift_version = '5.0'
  end