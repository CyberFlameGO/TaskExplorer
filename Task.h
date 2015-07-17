//
//  Task.h
//  TaskExplorer
//
//  Created by Patrick Wardle on 5/2/15.
//  Copyright (c) 2015 Lucas Derraugh. All rights reserved.
//

#import "Binary.h"
#import <Foundation/Foundation.h>


/*

//32bit
struct dyld_image_info_32 {
    int	imageLoadAddress;
    int	imageFilePath;
    int imageFileModDate;
};
 
*/

@interface Task : NSObject
{
    //pid
    NSNumber* pid;
    
    //uid
    //uid_t uid;
    
    //main binary
    Binary* binary;
    
    //parent id
    NSNumber* ppid;
    
    //children (for tree view)
    NSMutableArray* children;
}


@property (nonatomic, retain)NSNumber* pid;

//main binary
@property(nonatomic, retain)Binary* binary;

//process args
@property(nonatomic, retain)NSMutableArray* arguments;

//loaded dylibs
@property(nonatomic, retain)NSMutableArray* dylibs;

//open files
@property(nonatomic, retain)NSMutableArray* files;

//connections
@property(nonatomic, retain)NSMutableArray* connections;

@property uid_t uid;
@property (nonatomic, retain)NSNumber* ppid;


//signing info
//@property(nonatomic, retain)NSDictionary* signingInfo;

//children
@property (nonatomic, retain)NSMutableArray* children;


/* METHODS */

//init w/ a pid + path
// note: icons are dynamically determined only when process is shown in alert
-(id)initWithPID:(NSNumber*)taskPID andPath:(NSString*)taskPath;

//get command-line args
-(void)getArguments;

-(void)generateBinaryInfo;

//enumerate all dylibs
// ->new ones are added to 'existingDylibs' (global) dictionary
-(void)enumerateDylibs:(NSXPCConnection*)xpcConnection allDylibs:(NSMutableDictionary*)allDylibs;

//enumerate all open files
-(void)enumerateFiles:(NSXPCConnection*)xpcConnection;

//enumerate network sockets/connections
-(void)enumerateNetworking:(NSXPCConnection*)xpcConnection;

//convert self to JSON string
// TODO: add dylibs, files, networking
-(NSString*)toJSON;

@end
