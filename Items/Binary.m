//
//  File.m
//  KnockKnock
//
//  Created by Patrick Wardle on 2/19/15.
//  Copyright (c) 2015 Objective-See. All rights reserved.
//


#import "Binary.h"
#import "Consts.h"
#import "Utilities.h"
#import "AppDelegate.h"

@implementation Binary

@synthesize path;
@synthesize name;
@synthesize icon;
@synthesize bundle;
@synthesize hashes;
@synthesize vtInfo;
@synthesize signingInfo;
@synthesize isTaskBinary;

//init method
-(id)initWithParams:(NSDictionary*)params
{
    //super
    // ->saves path, etc
    self = [super initWithParams:params];
    if(self)
    {
        //since path is always full path to binary
        // ->manaully try to find & load bundle (for .apps)
        self.bundle = findAppBundle(self.path);
        
        /* now we have bundle (maybe), try get name and icon */
        
        //get task's name
        // ->either from bundle or path's last component
        self.name = [self getName];
        
        //get task's icon
        // ->either from bundle or just use system icon
        self.icon = [self getIcon];
        
        //grab attributes
        //self.attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil];        
    }
           
//bail
bail:
    
    return self;
}

//get task's name
// ->either from bundle or path's last component
-(NSString*)getName
{
    //name
    NSString* taskName = nil;
    
    //try to get name from bundle
    // ->key 'CFBundleName'
    if(nil != self.bundle)
    {
        //extract name
        taskName = [self.bundle infoDictionary][@"CFBundleName"];
    }
    
    //no bundle/ or bundle lookup failed
    // ->just use last component of path
    if(nil == taskName)
    {
        //special case
        // ->kernel -> 'kernel_task'
        if(YES == [self.path isEqualToString:path2Kernel()])
        {
            //set kernel
            taskName = @"kernel_task";
        }
        //default
        // ->name is just last component of path
        else
        {
            //extract name
            taskName = [self.path lastPathComponent];
        }
    }
    
    return taskName;
}

//get an icon for a process
// ->for apps, this will be app's icon, otherwise just a standard system one
-(NSImage*)getIcon
{
    //icon's file name
    NSString* iconFile = nil;
    
    //icon's path
    NSString* iconPath = nil;
    
    //icon's path extension
    NSString* iconExtension = nil;
    
    //icon
    NSImage* taskIcon = nil;
    
    //for app's
    // ->extract their icon
    if(nil != self.bundle)
    {
        //get file
        iconFile = self.bundle.infoDictionary[@"CFBundleIconFile"];
        
        //get path extension
        iconExtension = [iconFile pathExtension];
        
        //if its blank (i.e. not specified)
        // ->go with 'icns'
        if(YES == [iconExtension isEqualTo:@""])
        {
            //set type
            iconExtension = @"icns";
        }
        
        //set full path
        iconPath = [self.bundle pathForResource:[iconFile stringByDeletingPathExtension] ofType:iconExtension];
        
        //load it
        taskIcon = [[NSImage alloc] initWithContentsOfFile:iconPath];
    }
    
    //process is not an app or couldn't get icon
    // ->try to get it via shared workspace
    if( (nil == self.bundle) ||
        (nil == taskIcon) )
    {
        //extract icon
        taskIcon = [[NSWorkspace sharedWorkspace] iconForFile:self.path];
    }
    
    return taskIcon;
}

//get signing info (which takes a while to generate)
// ->this method should be called in the background
-(void)generatedSigningInfo
{
    //set signing info
    self.signingInfo = extractSigningInfo(self.path);
    
    return;
}

//get detailed info (which takes a while to generate)
// ->only shown to user if they click 'info' so this method should be called in the background
-(void)generateDetailedInfo
{
    //grab file attributes
    self.attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil];

    //computes hashes
    // ->set 'md5' and 'sha1' iVars
    self.hashes = hashFile(self.path);
    
    //call into filter object to check if file is known
    // ->apple-signed or whitelisted
    //self.isTrusted = [((AppDelegate*)[[NSApplication sharedApplication] delegate]).filterObj isTrustedFile:self];
    
    return;
    
}


//format the signing info dictionary
-(NSString*)formatSigningInfo
{
    //pretty print
    NSMutableString* prettyPrint = nil;
    
    //sanity check
    if(nil == self.signingInfo)
    {
        //bail
        goto bail;
    }
    
    //switch on signing status
    switch([self.signingInfo[KEY_SIGNATURE_STATUS] integerValue])
    {
        //unsigned
        case errSecCSUnsigned:
        {
            //set string
            prettyPrint = [NSMutableString stringWithString:@"unsigned"];
            
            //brk
            break;
        }
            
        //errSecCSSignatureFailed
        case errSecCSSignatureFailed:
        {
            //set string
            prettyPrint = [NSMutableString stringWithString:@"invalid signature"];
            
            //brk
            break;
        }
            
        //happily signed
        case STATUS_SUCCESS:
        {
            //init
            prettyPrint = [NSMutableString string];//stringWithString:@"signed by:"];
            
            //add each signing auth
            for(NSString* signingAuthority in self.signingInfo[KEY_SIGNING_AUTHORITIES])
            {
                //append
                [prettyPrint appendString:[NSString stringWithFormat:@"%@, ", signingAuthority]];
            }
            
            //remove last comma & space
            if(YES == [prettyPrint hasSuffix:@", "])
            {
                //remove
                [prettyPrint deleteCharactersInRange:NSMakeRange([prettyPrint length]-2, 2)];
            }
            
            //brk
            break;
        }
    
        //unknown
        default:
            
            //set string
            prettyPrint = [NSMutableString stringWithFormat:@"unknown (status/error: %ld)", (long)[self.signingInfo[KEY_SIGNATURE_STATUS] integerValue]];
            
            //brk
            break;
    }
    
//bail
bail:
    
    return prettyPrint;
}

//convert object to JSON string
-(NSString*)toJSON
{
    //json string
    NSString *json = nil;
    
    //json data
    // ->for intermediate conversions
    NSData *jsonData = nil;
    
    //hashes
    NSString* fileHashes = nil;
    
    //signing info
    NSString* fileSigs = nil;
    
    //VT detection ratio
    NSString* vtDetectionRatio = nil;
    
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

    //init VT detection ratio
    vtDetectionRatio = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)[self.vtInfo[VT_RESULTS_POSITIVES] unsignedIntegerValue], (unsigned long)[self.vtInfo[VT_RESULTS_TOTAL] unsignedIntegerValue]];
    
    //init json
    json = [NSString stringWithFormat:@"\"name\": \"%@\", \"path\": \"%@\", \"hashes\": %@, \"signature(s)\": %@, \"VT detection\": \"%@\"", self.name, self.path, fileHashes, fileSigs, vtDetectionRatio];
    
    return json;
}


@end
