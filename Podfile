platform :ios, '11.0'

# ignore all warnings from all pods
#inhibit_all_warnings!
use_frameworks!

def mainPods
  pod 'RxSwift', '~>4.0'
  pod 'RxCocoa', '~>4.0'
  pod 'NVActivityIndicatorView', '~>4.0'
  pod 'NVActivityIndicatorView/AppExtension', '~>4.0'
end

target 'MVVMTemplate' do
  mainPods
end

def testing_pods
  mainPods
  pod 'RxTest', '~>4.0'
end

target 'MVVMTemplateTests' do
  testing_pods
end