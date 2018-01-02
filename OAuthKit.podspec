Pod::Spec.new do |s|
  s.name             = 'OAuthKit'
  s.version          = '1.0'
  s.summary          = 'A library makes OAuth2 handling in iOS more simple.'
 
  s.description      = <<-DESC
A library makes OAuth2 handling in iOS much more simple.
                       DESC
 
  s.homepage         = 'https://github.com/muhammadbassio/OAuthKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhammad Bassio' => 'muhammadbassio@muhammadbassio.com' }
  s.source           = { :git => 'https://github.com/muhammadbassio/OAuthKit.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.0'
  s.source_files = 'OAuthKit/OAuthKit/**/**/*.swift','OAuthKit/OAuthKit/**/*.swift','OAuthKit/OAuthKit/*.swift'
 
end