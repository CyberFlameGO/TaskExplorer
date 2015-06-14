//
//  File.m
//  KnockKnock
//
//  Created by Patrick Wardle on 2/19/15.
//  Copyright (c) 2015 Objective-See. All rights reserved.
//


#import "File.h"
#import "Consts.h"
#import "Utilities.h"
#import "AppDelegate.h"

@implementation File

@synthesize path;
@synthesize name;
@synthesize plist;
@synthesize bundle;
@synthesize hashes;
@synthesize signingInfo;

//@synthesize vtInfo;


//init method
-(id)initWithParams:(NSDictionary*)params
{
    //flag for directories
    BOOL isDirectory = NO;
    
    //super
    // ->saves path, etc
    self = [super initWithParams:params];
    if(self)
    {
        //always skip not-existent paths
        // ->also get set a directory flag at the same time ;)
        if(YES != [[NSFileManager defaultManager] fileExistsAtPath:params[KEY_RESULT_PATH] isDirectory:&isDirectory])
        {
            //err msg
            NSLog(@"OBJECTIVE-SEE ERROR: %@ not found", params[KEY_RESULT_PATH]);
            
            //set self to nil
            self = nil;
            
            //bail
            goto bail;
        }
        
        //if path is directory
        // ->treat is as a bundle
        if(YES == isDirectory)
        {
            //load bundle
            // ->save this into 'bundle' iVar
            if(nil == (bundle = [NSBundle bundleWithPath:params[KEY_RESULT_PATH]]))
            {
                //err msg
                NSLog(@"OBJECTIVE-SEE ERROR: couldn't create bundle for %@", params[KEY_RESULT_PATH]);
                
                //set self to nil
                self = nil;
                
                //bail
                goto bail;
            }
            
            //extract executable from bundle
            // ->save this into 'path' iVar
            if(nil == (self.path = self.bundle.executablePath))
            {
                //err msg
                //NSLog(@"OBJECTIVE-SEE ERROR: couldn't find executable in bundle %@", itemPath);
                
                //set self to nil
                self = nil;
                
                //bail
                goto bail;
            }
        }
        
        //save (optional) plist
        // ->ok if this is nil
        self.plist = params[KEY_RESULT_PLIST];

        //extract name
        self.name = [[self.path lastPathComponent] stringByDeletingPathExtension];
        
    }
           
//bail
bail:
    
    return self;
}

//get detailed info (which takes a while to generate)
// ->only shown to user if they click 'info' so this method is called in the background
-(void)generateDetailedInfo
{
    //grab attributes
    //TODO: done elsewhere?
    self.attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil];
    
    //computes hashes
    // ->set 'md5' and 'sha1' iVars
    self.hashes = hashFile(self.path);
    
    return;
}

//convert object to JSON string
-(NSString*)toJSON
{
    //json string
    NSString *json = nil;
    
    //json data
    // ->for intermediate conversions
    NSData *jsonData = nil;
    
    //plist
    NSString* filePlist = nil;
    
    //hashes
    NSString* fileHashes = nil;
    
    //signing info
    NSString* fileSigs = nil;
    
    //init file hash to default string
    // ->used when hashes are nil, or serialization fails
    fileHashes = @"\"unknown\"";
    
    //init file signature to default string
    // ->used when signatures are nil, or serialization fails
    fileSigs = @"\"unknown\"";
    
    //convert hashes to JSON
    if(nil != self.hashes)
    {
        //convert hash dictionary
        // ->wrap since we are serializing JSON
        @try
        {
            //convert
            jsonData = [NSJSONSerialization dataWithJSONObject:self.hashes options:kNilOptions error:NULL];
            if(nil != jsonData)
            {
                //convert data to string
                fileHashes = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }
        //ignore exceptions
        // ->file hashes will just be 'unknown'
        @catch(NSException *exception)
        {
            ;
        }
    }
    
    //convert signing dictionary to JSON
    if(nil != self.signingInfo)
    {
        //convert signing dictionary
        // ->wrap since we are serializing JSON
        @try
        {
            //convert
            jsonData = [NSJSONSerialization dataWithJSONObject:self.signingInfo options:kNilOptions error:NULL];
            if(nil != jsonData)
            {
                //convert data to string
                fileSigs = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }
        //ignore exceptions
        // ->file sigs will just be 'unknown'
        @catch(NSException *exception)
        {
            ;
        }
    }
    
    //provide a default string if the file doesn't have a plist
    if(nil == self.plist)
    {
        //set
        filePlist = @"n/a";
    }
    //use plist as is
    else
    {
        //set
        filePlist = self.plist;
    }
    
    //init VT detection ratio
    //vtDetectionRatio = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)[self.vtInfo[VT_RESULTS_POSITIVES] unsignedIntegerValue], (unsigned long)[self.vtInfo[VT_RESULTS_TOTAL] unsignedIntegerValue]];
    
    //init json
    json = [NSString stringWithFormat:@"\"name\": \"%@\", \"path\": \"%@\", \"plist\": \"%@\", \"hashes\": %@, \"signature(s)\": %@", self.name, self.path, filePlist, fileHashes, fileSigs];
    
    return json;
}


@end
