Pod::Spec.new do |s|
  s.name         = "IFToastingKit"
  s.version      = "0.1.0"
  s.summary      = "A client for the Campfire API based on AFNetworking."
  s.homepage     = "https://github.com/irrationalfab/IFToastingKit"
  s.license      = 'MIT'
  s.author       = { "Fabio Pelosin" => "fabiopelosin@gmail.com" }
  s.source       = { :git => "https://github.com/irrationalfab/IFToastingKit.git", :tag => "0.1.0" }
  s.platform     = :osx, '10.7'
  #s.ios.deployment_target = '5.0'
  #s.osx.deployment_target = '10.7'
  s.source_files = 'Classes/**/*'
  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'SBJson'
end
