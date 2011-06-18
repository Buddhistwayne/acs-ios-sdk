//
//  Cocoafish.h
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 1/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCUser.h"
#import "CCCheckin.h"
#import "CCPlace.h"
#import "CCStatus.h"
#import "FBConnect.h"
#import "CCPhoto.h"
#import "CCKeyValuePair.h"
#import "CCEvent.h"
#import "CCResponse.h"
#import "CCMessage.h"
#import "CCRequest.h"
#import "CCCollection.h"
#import "CCShareRequest.h"
#import "CCChat.h"

@protocol CCFBSessionDelegate;

@class CCDownloadManager;
@interface Cocoafish : NSObject<FBSessionDelegate, FBRequestDelegate, CCRequestDelegate> {
	id<CCFBSessionDelegate> _fbSessionDelegate;
	CCUser *_currentUser;
	NSString *_appKey;
	NSString *_consumerKey;
	NSString *_consumerSecret;
	NSString *_facebookAppId;
	Facebook *_facebook; // handles facebook authentication
	NSString *_cocoafishDir;
	CCDownloadManager *_downloadManager;
    NSString *_deviceToken; // For push notificaiton
}

@property(nonatomic, assign) id<CCFBSessionDelegate> _fbSessionDelegate;
@property(nonatomic, retain, readonly) CCDownloadManager *downloadManager;
@property(nonatomic, retain, readonly) NSString *cocoafishDir;
@property(nonatomic, retain, readwrite) NSString *deviceToken;

+(void)initializeWithAppKey:(NSString *)appKey customAppIds:(NSDictionary *)customAppIds;;
+(void)initializeWithOauthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret customAppIds:(NSDictionary *)customAppIds;;
+(Cocoafish *)defaultCocoafish;

-(NSString *)getAppKey;
-(NSString *)getOauthConsumerKey;
-(NSString *)getOauthConsumerSecret;
-(CCUser *)getCurrentUser;
-(Facebook *)getFacebook;
-(void)setCurrentUser:(CCUser *)user;
- (NSString*)udid; // get device id

-(void)facebookAuth:(NSArray *)permissions delegate:(id<CCFBSessionDelegate>)delegate;
-(void)unlinkFromFacebook:(NSError **)error;
-(BOOL)handleOpenURL:(NSURL *)url;

@end


// Your program should implement the delegate methods if you use cocoafish
// to perform facebook login
@protocol CCFBSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in to facebook.
 */
- (void)fbDidLogin;

/**
 * Called when the user dismissed the dialog without logging in to facebook.
 */
- (void)fbDidNotLogin:(BOOL)cancelled error:(NSError *)error;

@end

NSString* encodeToPercentEscapeString(NSString *string);
