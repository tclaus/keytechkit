//
//  SimpleFileInfo.m
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTFileInfo.h"
#import "Webservice.h"

@implementation KTFileInfo
{
    NSString* _fileDivider;
}

@synthesize isLoading = _isLoading;
@synthesize localFileURL = _localFileURL;

    static RKObjectMapping* _mapping;

- (id)init
{
    self = [super init];
    if (self) {
        _fileDivider = @"-+-";
    }
    return self;
}

/**
 Sets the object mapping
 */
+(id)mapping{
    
    if (!_mapping){
        _mapping = [RKObjectMapping mappingForClass:[KTFileInfo class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"FileID":@"fileID",
                                                       @"FileName":@"fileName",
                                                       @"FileSize":@"fileSize",
                                                       }];

        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *notesDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:@"FileInfos" statusCodes:statusCodes];
        
        [[RKObjectManager sharedManager]addResponseDescriptor:notesDescriptor];
        
    }
    return _mapping;
}

// Returns the shortende filename
-(NSString*)shortFileName{
    if(self.fileName !=nil){
//self.itemClassKey rangeOfString:@"_MI"].location !=NSNotFound
        
        NSUInteger location = [self.fileName rangeOfString:_fileDivider].location;
        
        if (location !=NSNotFound){ // Found divider
            
            NSArray *array = [self.fileName componentsSeparatedByString:@"."]; // Splitt to file attachment
            
            NSString* fileSuffix;
            NSString* fileNamePart;
            
            if ([array count]>1){
                fileSuffix = array[1];
                fileNamePart = array[0];
            } else
                fileNamePart = self.fileName;
            
            NSString* shortendFilename;
            
            // Find by divider
            NSArray* filenameParts = [fileNamePart componentsSeparatedByString:_fileDivider];
            if (filenameParts.count>1){
                // First part is the filename we want
                // second part can be thrown away
                
                shortendFilename = [NSString stringWithFormat:@"%@.%@",filenameParts[0],fileSuffix];
                
            }else
                shortendFilename = self.fileName;
            
            // Return the new, shortened filename
            return shortendFilename;
            
        }
        
    }
    
    return self.fileName;
}

/**
Checks if the file is already transferd to local machine
 */
-(BOOL)isLocalLoaded{
    
    // Objekt ist nicht zugewiesen

    return self.localFileURL !=nil;
        

}

// Loads the file, if not locally available
//TODO: What is with chaing / Reloading ? 
-(NSURL *)loadRemoteFile{
    
    if (![self isLocalLoaded] && !_isLoading){
        NSString* resource = [NSString stringWithFormat:@"/files/%ld",(long)self.fileID];
    
        //NSURL *fileURL = [NSURL URLWithString:resource relativeToURL:[[RKObjectManager sharedManager].HTTPClient baseURL]];
        //NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:fileURL];
        
        NSMutableURLRequest *request = [[RKObjectManager sharedManager].HTTPClient requestWithMethod:@"GET" path:resource parameters:nil ];
        
                                                   
        NSURLSession *session = [NSURLSession sharedSession];
        [[session downloadTaskWithRequest:request
                       completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                           NSLog(@"File loaded at: %@",location);
                           
                           [self willChangeValueForKey:@"localFileURL"];
                           _localFileURL = location;
                           _isLoading = NO;
                           [self didChangeValueForKey:@"localFileURL"];

                           
                       }] resume];
        
        
        
        _isLoading = YES;
        return nil;

    } else {
        return self.localFileURL;
    }
}


//* File was loaded. Send a FileLoaded through KVO
-(void)request:(id )request didLoadResponse:(id)response{
    

    NSURL* dataDir = [[[Webservice sharedWebservice]applicationDataDirectory] URLByAppendingPathComponent:self.fileName];

    BOOL fileCreated = [[NSFileManager defaultManager] createFileAtPath:[dataDir path] contents:nil attributes:nil];
    if (fileCreated) {
            
    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:[dataDir path]];
    
    [file writeData:nil];
    [file closeFile];
    
        
        // If fast switching between files - a error might occure
        @try {
            [self willChangeValueForKey:@"localFileURL"];
            //_localURL = [NSURL fileURLWithPath:[dataDir absoluteString]];
            _localFileURL = dataDir;
            
            _isLoading = NO;
            [self didChangeValueForKey:@"localFileURL"];
            
        }
        @catch (NSException *exception) {
            // do nothing
        }
        @finally {
            // do nothing
        }
        

    }
    
    
}


/**
 Debugger helper
 */
-(NSString*)description{
    return [NSString stringWithFormat:@"ID: %ld, Filename: %@",(long)self.fileID, self.fileName];
}
@end





