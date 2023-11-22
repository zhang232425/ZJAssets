#
# Be sure to run `pod lib lint ZJAssets.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
  s.name             = 'ZJAssets'
  s.version          = '0.1.0'
  s.summary          = 'ZJAssets.'
  s.homepage         = 'https://github.com/zhang232425/ZJAssets'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhang232425' => 'yonathan@asetku.com' }
  s.source           = { :git => 'https://github.com/zhang232425/ZJAssets.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'

  s.source_files = 'ZJAssets/Classes/**/*'
  s.resource_bundles = {
      'ZJAssets' => ['ZJAssets/Assets/**/*']
  }
  s.static_framework = true
  
  s.dependency 'Then'
  s.dependency 'Action'
  s.dependency 'Charts'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'SwiftDate'
  s.dependency 'RxSwiftExt'
  s.dependency 'RxDataSources'
  s.dependency 'JXSegmentedView'
  s.dependency 'JXPagingView/Paging'
  
  s.dependency 'ZJRequest'
  s.dependency 'ZJLocalizable'
  s.dependency 'ZJRouter'
  s.dependency 'ZJRoutableTargets'
  s.dependency 'ZJBase'
  s.dependency 'ZJExtension'
  s.dependency 'ZJHUD'
  s.dependency 'ZJCommonView'
  s.dependency 'ZJRefresh'
  s.dependency 'ZJCommonDefines'
  s.dependency 'ZJRefresh'
  
  s.dependency 'ZJLogin'

  
end


