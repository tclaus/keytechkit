Pod::Spec.new do |spec|
  spec.name         = 'keytechkit'
  spec.version      = '0.1.13'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/vvanchesa/keytechkit'
  spec.authors      = { 'Thorsten Claus' => 'thorstenclaus@web.de' }
  spec.summary      = 'keytech SDK to access the keytech WebAPI.'
  spec.source       = { :git => 'https://github.com/vvanchesa/keytechkit.git', :tag => spec.version.to_s }
  spec.source_files = 'keytechKit/Code/**/*.{h,m}'
  spec.requires_arc = true
  spec.ios.deployment_target  = '8.0'
  spec.osx.deployment_target  = '10.9'
  spec.prefix_header_contents ='#import <RestKit/RestKit.h>'
  spec.dependency 'RestKit', '~>0.24'
  spec.dependency 'SSZipArchive'
end
