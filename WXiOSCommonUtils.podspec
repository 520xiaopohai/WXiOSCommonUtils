#
# Be sure to run `pod lib lint WXiOSCommonUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'WXiOSCommonUtils'
    s.version          = '0.1.4'
    s.summary          = 'A short description of WXiOSCommonUtils.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC

    s.homepage         = 'https://github.com/520xiaopohai/WXiOSCommonUtils'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'morty' => 'morty@wangxutech.com' }
    s.source           = { :git => 'https://github.com/520xiaopohai/WXiOSCommonUtils.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '10.0'

    s.resource_bundles = {
        'WXiOSCommonUtils' => ['WXiOSCommonUtils/WXiOSCommonUtilsSource/**/*']
    }


    s.subspec 'WXCustomUI' do |ss|
        ss.source_files = 'WXiOSCommonUtils/WXCustomUI/*'
    end


    s.subspec 'Utils' do |ss|
        ss.subspec 'DES' do |sss|
            sss.source_files = 'Utils/DES/*.{h,m}'
        end

#        ss.subspec 'ZipArchive' do |sss|
#            sss.source_files = 'Utils/ZipArchive/*.{h,m,mm,c}'
#        end
    end


    s.subspec 'Classes' do |ss|
        ss.source_files = 'WXiOSCommonUtils/Classes/*'
        ss.dependency 'AFNetworking','3.2.1'
        ss.dependency 'WXiOSCommonUtils/Utils/ZipArchive'
        ss.dependency 'WXiOSCommonUtils/Utils/DES'
        ss.library             = 'sqlite3'
        ss.xcconfig   = {
            'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/CommonCrypto' }
        ss.frameworks          =
        'CoreGraphics', 'Foundation', 'SystemConfiguration','Security', 'UIKit'
    end

    s.dependency 'YBNetwork'
    s.dependency 'YYImage'
    s.dependency 'SSZipArchive'
    s.xcconfig   = {
        'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/CommonCrypto' }
    s.library             = 'sqlite3'
    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'Photos','Security'
end
