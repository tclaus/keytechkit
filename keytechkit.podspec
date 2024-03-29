Pod::Spec.new do |spec|
  spec.name         = 'keytechkit'
  spec.version      = '0.2.11'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/tclaus/keytechkit'
  spec.authors      = { 'Thorsten Claus' => 'thorsten.claus@claus-software.de' }
  spec.summary      = 'keytech SDK to access the keytech software WebAPI'
  spec.source       = { :git => 'https://github.com/tclaus/keytechkit.git', :tag => spec.version.to_s }
  spec.source_files = 'keytechKit/Code/**/*.{h,m}'
  spec.requires_arc = true
  spec.ios.deployment_target  = '9.3'
  spec.osx.deployment_target  = '10.10'
  
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

  spec.dependency 'RestKit', '~>0.27'
  spec.dependency 'SSZipArchive'
end
