Pod::Spec.new do |spec|
  spec.name         = 'keytechkit'
  spec.version      = '0.1.11'
  spec.license      = { :type => 'Personal', :text => <<-LICENSE
/* Copyright (C) Claus-Software, Thorsten Claus, Inc - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* Written by Thorsten Claus <thorstenclaus@web.de>, September 2016
*/
LICENSE
}
  spec.homepage     = 'https://bitbucket.org/tclaus/keytechkit.git'
  spec.authors      = { 'Thorsten Claus' => 'thorstenclaus@web.de' }
  spec.summary      = 'keytech lib to access the keytech software Web-API.'
  spec.source       = { :git => 'https://bitbucket.org/tclaus/keytechkit.git', :tag => spec.version.to_s }
  spec.source_files = 'keytechKit/Code/**/*.{h,m}'
  spec.requires_arc = true
  spec.ios.deployment_target  = '8.0'
  spec.osx.deployment_target  = '10.9'
  spec.prefix_header_contents ='#import <RestKit/RestKit.h>'
  spec.dependency 'RestKit', '~>0.24'
  spec.dependency 'SSZipArchive'
end
