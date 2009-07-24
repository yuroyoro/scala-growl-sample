
#import <jni.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "info_growl_GrowlNative.h"

jclass		jListClass;
jmethodID	jListSize;
jmethodID	jListGet;

jclass		ntClass;
jmethodID	ntGetName;
jmethodID	ntIsEnabledByDefault;

/*
 * Convert a Java String into a Cocoa NSString.
 */
NSString *convertJavaStringToCocoa(JNIEnv *env, jstring javaString) {
	NSString	*cocoaString;
	const char	*nativeString;

	nativeString = env->GetStringUTFChars(javaString, JNI_FALSE);
	cocoaString = [NSString stringWithUTF8String:nativeString];

	return cocoaString;
}

/**
 * Initialise references to the necessary Java classes & methods.
 */
void initJavaRefs(JNIEnv *env) {
	jListClass = env->FindClass("java/util/List");
	jListSize = env->GetMethodID(jListClass, "size", "()I");
	jListGet = env->GetMethodID(jListClass, "get", "(I)Ljava/lang/Object;");

	ntClass = env->FindClass("info/growl/GrowlNative$NotificationType");
	ntGetName = env->GetMethodID(ntClass, "getName", "()Ljava/lang/String;");
	ntIsEnabledByDefault = env->GetMethodID(ntClass, "isEnabledByDefault", "()Z");
	
	env->ExceptionDescribe();
}

/*
 * Class:     info_growl_GrowlNative
 * Method:    sendNotification
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[B)V
 */
JNIEXPORT void JNICALL Java_info_growl_GrowlNative_sendNotification
(JNIEnv *env, jobject, jstring jAppName, jstring jNotifName, jstring jTitle,
	jstring jBody, jbyteArray jImage) {
	NSAutoreleasePool               *releasePool		= [[NSAutoreleasePool alloc] init];
	NSString						*appName			= convertJavaStringToCocoa(env, jAppName);
	NSString						*notifName			= convertJavaStringToCocoa(env, jNotifName);
	NSString						*title				= convertJavaStringToCocoa(env, jTitle);
	NSString						*body				= convertJavaStringToCocoa(env, jBody);
	NSDistributedNotificationCenter	*notifCenter		= [NSDistributedNotificationCenter defaultCenter];
	NSMutableDictionary				*notifDictionary	= [[NSMutableDictionary alloc] init];

	// initialise Java classes/methods
	initJavaRefs(env);

	// build the dictionary for the notification
	[notifDictionary setObject:appName forKey:@"ApplicationName"];

	[notifDictionary setObject:appName forKey:@"ApplicationName"];
	[notifDictionary setObject:notifName forKey:@"NotificationName"];
	[notifDictionary setObject:title forKey:@"NotificationTitle"];
	[notifDictionary setObject:body forKey:@"NotificationDescription"];

	if (jImage != NULL) {
		// notification has a custom icon - add it
		jbyte *nativeImageData = env->GetByteArrayElements(jImage, NULL);
		NSData *imageData = [NSData dataWithBytes:nativeImageData length:env->GetArrayLength(jImage)];
		env->ReleaseByteArrayElements(jImage, nativeImageData, JNI_ABORT);

		NSImage *image = [[NSImage alloc] initWithData:imageData];
		
		[notifDictionary setObject:[image TIFFRepresentation] forKey:@"NotificationIcon"];
	}

	// send the notification
	[notifCenter postNotificationName:@"GrowlNotification"
				object:nil
				userInfo:notifDictionary
				deliverImmediately:true];

	// clean up
	[releasePool release];
}


/*
 * Class:     info_growl_GrowlNative
 * Method:    registerApp
 * Signature: (Ljava/lang/String;[BLjava/util/List;)V
 */
JNIEXPORT void JNICALL Java_info_growl_GrowlNative_registerApp
(JNIEnv *env, jobject, jstring jAppName, jbyteArray jImage, jobject jNotifList) {
	NSAutoreleasePool               *releasePool    = [[NSAutoreleasePool alloc] init];
	NSDistributedNotificationCenter	*notifCenter	= [NSDistributedNotificationCenter defaultCenter];
	NSMutableDictionary				*regDictionary	= [[NSMutableDictionary alloc] init];
	NSString						*appName		= convertJavaStringToCocoa(env, jAppName);
	NSMutableArray					*notifNames		= [[NSMutableArray alloc] init];
	NSMutableArray					*defaultNotifs	= [[NSMutableArray alloc] init];

	// initialise Java classes/methods
	initJavaRefs(env);

	// build the dictionary for the registration
	[regDictionary setObject:appName forKey:@"ApplicationName"];

	// loop through the notifications and add them to the list
	int notifSize = env->CallIntMethod(jNotifList, jListSize);
	for (int i = 0; i < notifSize; i++) {
		jobject notifType = env->CallObjectMethod(jNotifList, jListGet, i);
		jstring jNotifName = (jstring)env->CallObjectMethod(notifType, ntGetName);
		NSString *notifName = convertJavaStringToCocoa(env, jNotifName);
		
		[notifNames addObject:notifName];
		
		if (env->CallBooleanMethod(notifType, ntIsEnabledByDefault)) {
			// add to default list
			[defaultNotifs addObject:notifName];
		}
	}

	[regDictionary setObject:notifNames forKey:@"AllNotifications"];
	[regDictionary setObject:defaultNotifs forKey:@"DefaultNotifications"];

	if (jImage != NULL) {
		// set the image for this application's registration
		jbyte *nativeImageData = env->GetByteArrayElements(jImage, NULL);
		NSData *imageData = [NSData dataWithBytes:nativeImageData length:env->GetArrayLength(jImage)];
		env->ReleaseByteArrayElements(jImage, nativeImageData, JNI_ABORT);

		NSImage *image = [[NSImage alloc] initWithData:imageData];
		
		[regDictionary setObject:[image TIFFRepresentation] forKey:@"ApplicationIcon"];
	}

	// send the registration
	[notifCenter postNotificationName:@"GrowlApplicationRegistrationNotification"
				object:nil
				userInfo:regDictionary
				deliverImmediately:true];

	// clean up
	[releasePool release];
}
