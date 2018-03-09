Pod::Spec.new do |s|
  s.name         = "WGQRadioGroup"
  s.version      = "0.3.1"
  s.summary      = "An easy to use radiogroup control."
  s.homepage     = "https://github.com/disburden/WGQRaidoGroup"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "disburden" => "disburden.gamil.com" }
  s.ios.deployment_target = "9.0"
  s.screenshot = 'https://raw.githubusercontent.com/disburden/WGQRaidoGroup/master/ScreenShots/screenshot1.png'
  s.source       = { :git => "https://github.com/disburden/WGQRaidoGroup.git", :tag => "#{s.version}" }
  s.source_files  = "WGQRadioGroup/**/*.swift"
  s.requires_arc = true
end
