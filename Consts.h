//
//  Consts.h
//  DHS
//
//  Created by Patrick Wardle on 2/4/15.
//  Copyright (c) 2015 Objective-See. All rights reserved.
//

#ifndef KK_Consts_h
#define KK_Consts_h

//button text, start scan
#define START_SCAN @"Start Scan"

//button text, stop scan
#define STOP_SCAN @"Stop Scan"

//status msg
#define SCAN_MSG_STARTED @"scanning started"

//status msg
#define SCAN_MSG_STOPPED @"scan stopped"

//status msg
#define SCAN_MSG_COMPLETE @"scan complete"

//success
#define STATUS_SUCCESS 0

//keys for signing stuff
#define KEY_SIGNATURE_STATUS @"signatureStatus"
#define KEY_SIGNING_AUTHORITIES @"signingAuthorities"
#define KEY_SIGNING_IS_APPLE @"signedByApple"

//OS version x
#define OS_MAJOR_VERSION_X 10

//OS version lion
#define OS_MINOR_VERSION_LION 8

//OS version yosemite
#define OS_MINOR_VERSION_YOSEMITE 10


//executable path
#define EXECUTABLE_PATH @"@executable_path"

//loader path
#define LOADER_PATH @"@loader_path"

//rpath
#define RUN_SEARCH_PATH @"@rpath"

//path to LSOF
#define LSOF @"/usr/sbin/lsof"

//hash key, SHA1
#define KEY_HASH_SHA1 @"sha1"

//hash key, MD5
#define KEY_HASH_MD5 @"md5"

//path to system profiler
#define SYSTEM_PROFILER @"/usr/sbin/system_profiler"

//dyld_ key for launch items
#define LAUNCH_ITEM_DYLD_KEY @"EnvironmentVariables"

//dyld_ key for applications
#define APPLICATION_DYLD_KEY @"LSEnvironment"

//menu

//tag for prefs menu item
#define PREF_MENU_ITEM_TAG 1

//main window

//space for File's button in time table (w/ VT info)
#define TABLE_BUTTONS_FILE 225

//space for Extension's button in time table
#define TABLE_BUTTONS_EXTENTION 135


//scan button
#define SCAN_BUTTON_TAG 1000

//pref button
#define PREF_BUTTON_TAG 1001

//logo button
#define LOGO_BUTTON_TAG 1002

//category table


//id (tag) for detailed text in category table
#define TABLE_ROW_NAME_TAG 100

//id (tag) for detailed text in category table
#define TABLE_ROW_SUB_TEXT_TAG 101

//id (tag) for total's msg
#define TABLE_ROW_TOTAL_TAG 102


//item table

//id (tag) for signed icon
#define TABLE_ROW_SIGNATURE_ICON 100

//id (tag) for path
#define TABLE_ROW_PATH_LABEL 101

//id (tag) for plist
#define TABLE_ROW_PID_LABEL 102

//id (tag) for 'virus total' button
#define TABLE_ROW_VT_BUTTON 103

//id (tag) for 'info' button
#define TABLE_ROW_INFO_BUTTON 105

//id (tag) for 'show' button
#define TABLE_ROW_SHOW_BUTTON 107

//ellipis
// ->for long paths...
#define ELLIPIS @"..."

//known file hashes
#define WHITE_LISTED_FILES @"whitelistedFiles"

//known commands
#define WHITE_LISTED_COMMANDS @"whitelistedCommands"

//known extension hashes
#define WHITE_LISTED_EXTENSIONS @"whitelistedExtensions"

//scanner option key
// ->filter apple signed/known items
#define KEY_SCANNER_FILTER @"filterItems"

//plugin key
//#define KEY_RESULT_PLUGIN @"plugin"

//XPC Service name
#define XPC_SERVICE @"remoteTaskService.xpc"

//location of kernel in pre-Yosemite
#define KERNEL_PRE_YOSEMITE @"/System/Library/Kernels/kernel"

//location of kernel in Yosemite
#define KERNEL_YOSEMITE @"/System/Library/Kernels/kernel"

//top pane

//top
#define PANE_TOP 0x0


//for prefs
//#define PREF_FIRST_RUN @"isFirstRun"

//flat view
#define FLAT_VIEW 100

//tree view
#define TREE_VIEW 101

//bottom pane

//top
#define PANE_BOTTOM 0x1

//any view
// ->not in UI
#define CURRENT_VIEW -1

//dylib view
#define DYLIBS_VIEW 0

//file view
#define FILES_VIEW 1

//networking view
#define NETWORKING_VIEW 2

//pid
#define KEY_RESULT_PID @"pid"

//name key
#define KEY_RESULT_NAME @"name"

//path key
#define KEY_RESULT_PATH @"path"

//plist key
#define KEY_RESULT_PLIST @"plist"

//extension id key
#define KEY_EXTENSION_ID @"id"

//extension description key
#define KEY_EXTENSION_DETAILS @"details"

//extension (host) browser key
#define KEY_EXTENSION_BROWSER @"browser"

/* VIRUS TOTAL */

//query url
#define VT_QUERY_URL @"https://www.virustotal.com/partners/sysinternals/file-reports?apikey="

//requery url
#define VT_REQUERY_URL @"https://www.virustotal.com/vtapi/v2/file/report"

//rescan url
#define VT_RESCAN_URL @"https://www.virustotal.com/vtapi/v2/file/rescan"

//submit url
#define VT_SUBMIT_URL @"https://www.virustotal.com/vtapi/v2/file/scan"

//api key
#define VT_API_KEY @"233f22e200ca5822bd91103043ccac138b910db79f29af5616a9afe8b6f215ad"

//user agent
#define VT_USER_AGENT @"VirusTotal"

//query count
#define VT_MAX_QUERY_COUNT 25

//results
#define VT_RESULTS @"data"

//results response code
#define VT_RESULTS_RESPONSE @"response_code"

//result url
#define VT_RESULTS_URL @"permalink"

//result hash
#define VT_RESULT_HASH @"hash"

//results positives
#define VT_RESULTS_POSITIVES @"positives"

//results total
#define VT_RESULTS_TOTAL @"total"

//results scan id
#define VT_RESULTS_SCANID @"scan_id"

//output file
#define OUTPUT_FILE @"kkFindings.txt"

//keys/types for XPC dictionaries

//descriptor type
#define KEY_DESCRIPTOR_TYPE @"descriptorType"

//file path
#define KEY_FILE_PATH @"filePath"

//socket local ip addr
#define KEY_LOCAL_ADDR @"localIPAddr"

//socket local port
#define KEY_LOCAL_PORT @"localPort"

//socket remote ip addr
#define KEY_REMOTE_ADDR @"remoteIPAddr"

//socket remote port
#define KEY_REMOTE_PORT @"remotePort"

//socket state
#define KEY_SOCKET_STATE @"socketState"

//socket type
#define KEY_SOCKET_TYPE @"socketType"

//socket family
#define KEY_SOCKET_FAMILY @"socketFamily"

//socket protocol
#define KEY_SOCKET_PROTO @"socketProto"

//listening socket
#define SOCKET_LISTENING @"listening"

//connected socket
#define SOCKET_ESTABLISHED @"connected"





#endif
