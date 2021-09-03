#
# Be sure to run `pod lib lint Zelda.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ComponentBus'
  s.version          = '0.0.1'
  s.summary          = 'ComponentBus是一个基于组件总线的通信框架。'
  s.description      = <<-DESC
                       ComponentBus是一个基于组件总线的通信框架，支持渐进式组件化。
                       DESC
  s.homepage         = 'https://github.com/ljunb/ComponentBus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ljunb' => '824771861@qq.com' }
  s.source           = { :git => 'https://github.com/ljunb/ComponentBus.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/**/*'

end
