Pod::Spec.new do |spec|
  spec.name         = 'keytechkit'
  spec.version      = '0.1.16'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/vvanchesa/keytechkit'
  spec.authors      = { 'Thorsten Claus' => 'thorstenclaus@web.de' }
  spec.summary      = 'keytech SDK to access the keytech WebAPI.'
  spec.source       = { :git => 'https://github.com/vvanchesa/keytechkit.git', :tag => spec.version.to_s }
  spec.source_files = 'keytechKit/Code/**/*.{h,m}'
  spec.requires_arc = true
  spec.ios.deployment_target  = '8.0'
  spec.osx.deployment_target  = '10.9'
  
  spec.ios.frameworks = 'MobileCoreServices', 'SystemConfiguration'
  spec.osx.frameworks = 'CoreServices', 'SystemConfiguration'

  spec.prefix_header_contents ='
   #if __IPHONE_OS_VERSION_MIN_REQUIRED
        #import <SystemConfiguration/SystemConfiguration.h>
        #import <MobileCoreServices/MobileCoreServices.h>
    #else
        #import <SystemConfiguration/SystemConfiguration.h>
        #import <CoreServices/CoreServices.h>
    #endif
    #import <RestKit/RestKit.h>'

  spec.dependency 'RestKit', '~>0.24'
  spec.dependency 'SSZipArchive'
end
