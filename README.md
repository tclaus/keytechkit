# keytechKit

keytechKit is a iOS / OSX framework for accessing the german keytech PLM Web API. 

[![Build Status](https://travis-ci.org/vvanchesa/keytechkit.svg?branch=master)](https://travis-ci.org/vvanchesa/keytechkit)

## Start building a project

In your project folder do a 
pod init
to create a smart podfile with some defaults.

Thens simply add the following to your Podfile:
``` ruby
pod 'keytechkit', '~>0.2'
```

keytechKit works for iOS >=8 and OSX >=10.9

Please remind that keytech provides a public Web-API to test and develop, but to use this in your own envoronment you will need a suitable license. Contact keytech for terms and conditions.

## What can you do with this?

keytechKit supports: 
Most of keytech Web-API ressources: 
* Search for elements: by Text, direct field value, with class restrictions
* Creating, updating and deleting of elements
* Loading of Elements Structure, WhereUsed, Thumbnails, Notes, Bom, Files
* Fetching User with favorites, stored queries
* Fetching class definitions 


## How do I get set up?

Add the pod and then start to connect to a server: 

``` Objective-C
    // Read ServerURL from environment
    NSString *serverURL = [[[NSProcessInfo processInfo]environment] objectForKey:@"APIURL"]; 
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

Start a simple query

To start a query to get elements with the keyword 'Steam' in it, check this code: 

``` Objective-C

    // Start a paging object 
    KTPagedObject *paging = [KTPagedObject initWithPage:1
                                                   size:10];
    
    NSString *searchtext = @"Steam";  // Search 'Steam' related elements

    KTQuery *query = [[KTQuery alloc]init];
    [query queryByText:searchtext           // a text based search
                fields:nil                  // no special fields
             inClasses:nil                  // no special keytech classes (all in this case) 
                reload:false                //                  
                 paged:paging               // use a paging object
               success:^(NSArray *results) {
                    // results is a array with KTElement Objects in it
                   [self progressElements:results];
               }
               failure:^(NSError* error){
                   // Progress the error
               }];

```

Fields and Classes can be an array to specify more preciecly the results.


You can of course use a swift project. Ask me if you are interested in more samples in swift.


## License
keytechKit is licensed under the MIT license. Read the LICENSE file for details.


## Who do I talk to? ###

keytechKit was made and is maintenanced by [Thorsten Claus](https://claus-software.de)



