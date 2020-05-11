#
# Be sure to run `pod lib lint WXiOSCommonUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WXiOSCommonUtils'
  s.version          = '0.1.2'
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

  s.ios.deployment_target = '9.0'
  s.source_files     = 'WXiOSCommonUtils/WXiOSCommonUtils.{h,m}'
  s.resource_bundles = {
    'WXiOSCommonUtils' => ['WXiOSCommonUtils/WXiOSCommonUtilsSource/**/*']
  }


  s.subspec 'WXCustomUI' do |ss|
    ss.source_files = 'WXiOSCommonUtils/WXiOSCommonUtils.h', 'WXiOSCommonUtils/WXCustomUI/**/*'
  end


  s.subspec 'Utils' do |ss|
    ss.subspec 'DES' do |sss|
      sss.source_files = 'WXiOSCommonUtils/Utils/DES/*.{h,m}'
      sss.frameworks  = 'Foundation', 'CommonCrypto'
    end

    ss.subspec 'libPhoneNumber' do |sss|
      sss.source_files = 'WXiOSCommonUtils/Utils/libPhoneNumber/*.{h,m,sh,plist}'
      sss.frameworks  = 'Foundation', 'CommonCrypto'
    end

    ss.subspec 'ZipArchive' do |sss|
      sss.source_files = 'WXiOSCommonUtils/Utils/ZipArchive/*.{h,m,mm,c}'
      sss.frameworks  = 'Foundation', 'CommonCrypto'
    end
  end


  s.subspec 'WXUtils' do |ss|
    ss.subspec 'WXCommLog' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommLog/WXCommLog.{h,m}'
#      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommTools'
#      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommSettings'
#      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommDevice'
#      sss.dependency 'WXiOSCommonUtils/WXUtils/WXInterface'
    end

    ss.subspec 'WXCommKeychain' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommKeychain/WXCommKeychain.{h,m}'
    end

    ss.subspec 'WXInterface' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXInterface/*.{h,m}','WXiOSCommonUtils/WXiOSCommonUtils.h'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommTools'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommSettings'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommDevice'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommInterface'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXUserDefaultKit'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommDevice'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommShare'
      sss.dependency 'WXiOSCommonUtils/WXUtils/Category'

    end

    ss.subspec 'WXCommTools' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommTools/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/Utils/ZipArchive'
      sss.dependency 'WXiOSCommonUtils/Utils/DES'
      sss.dependency 'WXiOSCommonUtils/WXUtils/Category'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommLog'
      sss.frameworks  = 'Foundation', 'UIKit', 'AVFoundation'
    end

    ss.subspec 'WXCustomView' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCustomView/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommTools'
      sss.frameworks  = 'Foundation', 'UIKit', 'AVFoundation'
    end

    ss.subspec 'WXCommShare' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommShare/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommLog'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommDevice'
      sss.frameworks  = 'Foundation', 'UIKit', 'AVFoundation'
    end

    ss.subspec 'Category' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/Category/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommLog'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommDevice'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommShare'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXAnimatedImageView'
      sss.frameworks  = 'Foundation', 'CommonCrypto', 'AVFoundation','UIKit'
    end

    ss.subspec 'WXAccountCenter' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXAccountCenter/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXUserDefaultKit'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXInterface'
      sss.dependency 'AFNetworking','3.2.1'

    end

    ss.subspec 'WXDatabaseManager' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXDatabaseManager/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXUserDefaultKit'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXInterface'
      sss.dependency 'AFNetworking','3.2.1'
    end


    ss.subspec 'WXAnimatedImageView' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXAnimatedImageView/*.{h,m}'
      sss.frameworks =  'ImageIO'
    end

    ss.subspec 'WXCommPassportInfo' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommPassportInfo/*.{h,m}'
    end


    ss.subspec 'WXAutoCheckUpdate' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXAutoCheckUpdate/*.{h,m}'
    end


    ss.subspec 'WXCommSettings' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommSettings/*.{h,m}','WXiOSCommonUtils/WXiOSCommonUtils.h'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXUserDefaultKit'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommTools'
    end

    ss.subspec 'WXCommDevice' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXCommDevice/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommKeychain'
      sss.frameworks = 'SystemConfiguration'
    end

    ss.subspec 'WXNetworkCommInterfce' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXNetworkCommInterfce/*.{h,m}'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommKeychain'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommSettings'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommDevice'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommlog'
      sss.dependency 'WXiOSCommonUtils/WXUtils/WXCommTools'
      sss.dependency 'AFNetworking','3.2.1'
    end

    ss.subspec 'WXUserDefaultKit' do |sss|
      sss.source_files = 'WXiOSCommonUtils/WXUtils/WXUserDefaultKit/*.{h,m}'
      sss.frameworks = 'UIKit'
    end


  end


  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'Photos'

  s.dependency 'YBNetwork'
  s.dependency 'YYImage'
end
