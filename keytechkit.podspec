Pod::Spec.new do |spec|
  spec.name         = 'keytechKit'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://bitbucket.org/tclaus/keytechkit.git'
  spec.authors      = { 'Thorsten Claus' => 'thorstenclaus@web.de' }
  spec.summary      = 'keytech kit'
  spec.source       = { :git => 'https://bitbucket.org/tclaus/keytechkit.git', :tag => spec.version.to_s }
  spec.source_files = 'keytechKit/Code/**/*.{h,m}'
  spec.requires_arc = true
  spec.ios.deployment_target  = '7.0'
  spec.osx.deployment_target  = '10.9'
  spec.prefix_header_contents ='#import <RestKit/RestKit.h>'
  spec.dependency 'RestKit', '~>0.24'
  spec.dependency 'SSZipArchive', '~>0.3'
end