Pod::Spec.new do |s|

  s.name                 = "FLVideoBGM"
  s.version              = "1.0.1"
  s.summary              = "This repository encapsulate a function for adding background music to a video."
  s.homepage             = "https://github.com/filelife/FLVideoBGM"
  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author               = { "gejiaxin" => "filelife@icloud.com" }
  s.social_media_url     = "https://github.com/filelife"
  s.platform             = :ios, "7.0"
  s.source               = { :git => "https://github.com/filelife/FLVideoBGM.git", :tag => s.version }
  s.source_files         = "FLVideoBGM/**/*.{h,m}"
  s.requires_arc         = true
end

