/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class info_growl_GrowlNative */

#ifndef _Included_info_growl_GrowlNative
#define _Included_info_growl_GrowlNative
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     info_growl_GrowlNative
 * Method:    sendNotification
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[B)V
 */
JNIEXPORT void JNICALL Java_info_growl_GrowlNative_sendNotification
  (JNIEnv *, jobject, jstring, jstring, jstring, jstring, jbyteArray);

/*
 * Class:     info_growl_GrowlNative
 * Method:    registerApp
 * Signature: (Ljava/lang/String;[BLjava/util/List;)V
 */
JNIEXPORT void JNICALL Java_info_growl_GrowlNative_registerApp
  (JNIEnv *, jobject, jstring, jbyteArray, jobject);

#ifdef __cplusplus
}
#endif
#endif
