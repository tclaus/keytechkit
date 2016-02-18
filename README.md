# keytechKit

keytechKit is a iOS / OSX framework for accessing the keytech WebAPI. 

## Start building a project

Simply add the following to your Podfile using CocoaPods:
``` ruby
pod 'keytechkit', '~>0.1'
```

keytechKit works for iOS >=8 and OSX >=10.9

Please remind that keytech provides a public Web-API to test and develop, but to use this in your own envoronment you will need a suitable license. Contact keytech for terms and conditions.

## How do I get set up?

Add the pod, and then start to connect to a server: 

``` Objective-C
    NSString *serverURL = [[[NSProcessInfo processInfo]environment] objectForKey:@"APIURL"]; // Read from envorinment
    NSString *username = [[[NSProcessInfo processInfo]environment] objectForKey:@"APIUserName"];
    
    // Setup credentials
    [KTManager sharedManager].servername = serverURL;
    [KTManager sharedManager].username =username;
    [[KTManager sharedManager]  synchronizeServerCredentials];
    // Read Server side basic information
    [[KTServerInfo sharedServerInfo] waitUnitlLoad];
    
    [[KTServerInfo sharedServerInfo]loadWithSuccess:^(KTServerInfo *serverInfo) {
        // Store some basic Infos
        NSString *apiVersion = serverInfo.APIVersion;
        NSString *baseURL = [KTServerInfo sharedServerInfo].baseURL;
        
    } failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:error.localizedDescription
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }];
```


## License
keytechKit is licensed under the MIT license. Read the LICENSE file for details.

## Who do I talk to? ###

keytechKit was made and is maintenanced by [Thorsten Claus](https://twitter.com/vanchesa)
