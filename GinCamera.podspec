Pod::Spec.new do |s|
    s.name         = "GinCamera"
    s.version      = "1.0.0"
    s.summary      = "This is one of my personal library."
    s.homepage     = "https://github.com/ginhoor/GinhoorSpecs"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author       = { "JunhuaShao" => "ginhoor@gmail.com" }

    s.requires_arc = true
    s.platform     = :ios, "10.0"

    s.source       = { :git => "https://github.com/ginhoor/GinCamera.git", :tag => s.version.to_s }

    #s.source_files  = "GinhoorFramework/GinhoorFramework.h"
    #s.public_header_files = 'GinhoorFramework/GinhoorFramework.h'

    # 用来指定外部的静态库
    # s.vendored_libraries = ''

    # s.resource  = "icon.png"
    # s.resources = "GinhoorFramework/Framework/**/*.png"
    # 表示需要保留的文件路径
    # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

    s.frameworks = "Foundation", "CoreGraphics", "UIKit"

    # s.library   = "libxml2"
    # s.libraries = "iconv", "xml2"

    s.subspec 'PhotoCaptureManager' do |ss|
        ss.dependency 'GinhoorFramework', '~> 2.2.14'
        ss.source_files = 'GinCamera/*.{h,m}'
        ss.source_files = 'GinCamera/PhotoCaptureManager/*.{h,m}'
    end

    s.subspec 'VideoCaptureManager' do |ss|
        ss.dependency 'GinhoorFramework', '~> 2.2.14'
        ss.source_files = 'GinCamera/*.{h,m}'
        ss.source_files = 'GinCamera/VideoCaptureManager/*.{h,m}'
    end

    s.subspec 'SystemCaptureManager' do |ss|
        ss.dependency 'GinhoorFramework', '~> 2.2.14'
        ss.dependency 'TOCropViewController', '~> 2.4'
        ss.source_files = 'GinCamera/*.{h,m}'
        ss.source_files = 'GinCamera/SystemCaptureManager/*.{h,m}'
    end

end
