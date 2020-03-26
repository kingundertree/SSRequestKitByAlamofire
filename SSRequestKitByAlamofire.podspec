Pod::Spec.new do |s|
  s.name         = "SSRequestKitByAlamofire"
  s.version      = "0.0.1"
  s.summary      = "A short description of SSRequestKitByAlamofire."
  s.description  = <<-DESC
                    Hi, SSRequestKitByAlamofire!
                   DESC
  s.homepage     = "git@gitee.com:xiazer/SSRequestKitByAlamofire.git"
  s.license      = "MIT"
  s.author       = { "Summer Solstice" => "kingundertree@163.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "git@gitee.com:xiazer/SSRequestKitByAlamofire.git", :tag => "#{s.version}" }
s.source           = { :git => '', :tag => s.version.to_s }

  s.source_files        = 'Sources/*.h'
  s.public_header_files = 'Sources/*.h'
#  s.static_framework = true
#  s.ios.resources = ["Resources/**/*.{png,json}","Resources/*.{html,png,json}", "Resources/*.{xcassets, json}", "Sources/**/*.xib"]

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Core/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Core/*.h'
  end

  s.subspec 'Adater' do |ss|
    ss.source_files = 'Sources/Adater/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Adater/*.h'
  end

  s.subspec 'Retrier' do |ss|
    ss.source_files = 'Sources/Retrier/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Retrier/*.h'
  end

  s.subspec 'Config' do |ss|
    ss.source_files = 'Sources/Config/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Config/*.h'
  end

  s.subspec 'SSApi' do |ss|
    ss.source_files = 'Sources/SSApi/*.{h,m,swift}'
    ss.public_header_files = 'Sources/SSApi/*.h'
  end

  s.subspec 'Result' do |ss|
    ss.source_files = 'Sources/Result/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Result/*.h'
  end

  s.subspec 'Others' do |ss|
    ss.source_files = 'Sources/Others/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Others/*.h'
  end

  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  
end
