//
//  AXSHKConfigurator.m
//  Meme Storm
//
//  Created by Vinh Nguyen on 1/6/13.
//  Copyright (c) 2013 Vinh Nguyen. All rights reserved.
//

#import "AXSHKConfigurator.h"
#import "AXConfig.h"

@implementation AXSHKConfigurator

- (NSString*)appName {
	return @"Meme Storm";
}

- (NSString*)appURL {
	return @"http://memestorm.axcoto.com";
}

/*
 API Keys
 --------
 This is the longest step to getting set up, it involves filling in API keys for the supported services.
 It should be pretty painless though and should hopefully take no more than a few minutes.
 
 Each key below as a link to a page where you can generate an api key.  Fill in the key for each service below.
 
 A note on services you don't need:
 If, for example, your app only shares URLs then you probably won't need image services like Flickr.
 In these cases it is safe to leave an API key blank.
 
 However, it is STRONGLY recommended that you do your best to support all services for the types of sharing you support.
 The core principle behind ShareKit is to leave the service choices up to the user.  Thus, you should not remove any services,
 leaving that decision up to the user.
 */

// Vkontakte
// SHKVkontakteAppID is the Application ID provided by Vkontakte
- (NSString*)vkontakteAppId {
	return @"";
}



//Change if your app needs some special Facebook permissions only. In most cases you can leave it as it is.

// new with the 3.1 SDK facebook wants you to request read and publish permissions separatly. If you don't
// you won't get a smooth login/auth flow. Since ShareKit does not require any read permissions.
- (NSArray*)facebookWritePermissions {
    return [NSArray arrayWithObjects:@"publish_actions", nil];
}
- (NSArray*)facebookReadPermissions {
    return nil;	// this is the defaul value for the SDK and will afford basic read permissions
}

/*
 If you want to force use of old-style, posting path that does not use the native sheet. One of the troubles
 with the native sheet is that it gives IOS6 props on facebook instead of your app. This flag has no effect
 on the auth path. It will try to use native auth if availible.
 */
- (NSNumber*)forcePreIOS6FacebookPosting {
	return [NSNumber numberWithBool:NO];
}

// Facebook - https://developers.facebook.com/apps
// SHKFacebookAppID is the Application ID provided by Facebook
// SHKFacebookLocalAppID is used if you need to differentiate between several iOS apps running against a single Facebook app. Useful, if you have full and lite versions of the same app,
// and wish sharing from both will appear on facebook as sharing from one main app. You have to add different suffix to each version. Do not forget to fill both suffixes on facebook developer ("URL Scheme Suffix"). Leave it blank unless you are sure of what you are doing.
// The CFBundleURLSchemes in your App-Info.plist should be "fb" + the concatenation of these two IDs.
// Example:
//    SHKFacebookAppID = 555
//    SHKFacebookLocalAppID = lite
//
//    Your CFBundleURLSchemes entry: fb555lite
- (NSString*)facebookAppId {
	return @"520522971324913";
}

- (NSString*)facebookLocalAppId {
	return @"";
}

// Twitter - http://dev.twitter.com/apps/new
/*
 Important Twitter settings to get right:
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */

- (NSNumber*)forcePreIOS5TwitterAccess {
    return [NSNumber numberWithBool:false];
}

- (NSString*)twitterConsumerKey {
	return @"td6sKUTGTqvYOSpvw3LDCg";
}

- (NSString*)twitterSecret {
	return @"al2VyCG1ep60uk78Sg8junI1drHeVzRtGdZXnqoMlI";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://meme-storm.axcoto.com/thanks";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"";
}
// Evernote - http://www.evernote.com/about/developer/api/
/*	You need to set to sandbox until you get approved by evernote
 // Sandbox
 #define SHKEvernoteUserStoreURL    @"https://sandbox.evernote.com/edam/user"
 #define SHKEvernoteNetStoreURLBase @"http://sandbox.evernote.com/edam/note/"
 
 // Or production
 #define SHKEvernoteUserStoreURL    @"https://www.evernote.com/edam/user"
 #define SHKEvernoteNetStoreURLBase @"http://www.evernote.com/edam/note/"
 */

- (NSString *)evernoteHost {
    return @"sandbox.evernote.com";
}

- (NSString*)evernoteConsumerKey {
	return @"hansmeyer0711-4037";
}

- (NSString*)evernoteSecret {
	return @"e9d68467cd4c1aeb";
}
// Flickr - http://www.flickr.com/services/apps/create/
/*
 1 - This requires the CFNetwork.framework
 2 - One needs to setup the flickr app as a "web service" on the flickr authentication flow settings, and enter in your app's custom callback URL scheme.
 3 - make sure you define and create the same URL scheme in your apps info.plist. It can be as simple as yourapp://flickr */
- (NSString*)flickrConsumerKey {
    return @"72f05286417fae8da2d7e779f0eb1b2a";
}

- (NSString*)flickrSecretKey {
    return @"b5e731f395031782";
}
// The user defined callback url
- (NSString*)flickrCallbackUrl{
    return @"app://flickr";
}

// Bit.ly for shortening URLs in case you use original SHKTwitter sharer (pre iOS5). If you use iOS 5 builtin framework, the URL will be shortened anyway, these settings are not used in this case. http://bit.ly/account/register - after signup: http://bit.ly/a/your_api_key If you do not enter credentials, URL will be shared unshortened.
- (NSString*)bitLyLogin {
	return @"vilem";
}

- (NSString*)bitLyKey {
	return @"R_466f921d62a0789ac6262b7711be8454";
}

// LinkedIn - https://www.linkedin.com/secure/developer
- (NSString*)linkedInConsumerKey {
	return @"9f8m5vx0yhjf";
}

- (NSString*)linkedInSecret {
	return @"UWGKcBWreMKhwzRG";
}

- (NSString*)linkedInCallbackUrl {
	return @"http://yourdomain.com/callback";
}

- (NSString*)readabilityConsumerKey {
	return @"11388-eb66014a5b3f78055f0d2880";
}

- (NSString*)readabilitySecret {
	return @"RGXDE6wTygKtkwDBHpnjCAyvz2dtrhLD";
}

//Only supports XAuth currently
- (NSNumber*)readabilityUseXAuth {
    return [NSNumber numberWithInt:1];;
}
// Foursquare V2 - https://developer.foursquare.com
- (NSString*)foursquareV2ClientId {
    return @"NFJOGLJBI4C4RSZ3DQGR0W4ED5ZWAAE5QO3FW02Z3LLVZCT4";
}

- (NSString*)foursquareV2RedirectURI {
    return @"app://foursquare";
}

/*
 UI Configuration : Basic
 ------------------------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

- (UIColor*)barTintForView:(UIViewController*)vc {
	
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKTwitter"])
        return [UIColor colorWithRed:0 green:151.0f/255 blue:222.0f/255 alpha:1];
    
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKFacebook"])
        return [UIColor colorWithRed:59.0f/255 green:89.0f/255 blue:152.0f/255 alpha:1];
    
    return nil;
}

@end
