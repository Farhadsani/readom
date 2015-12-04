//
//  Debug.h
//  
//
//  Created by wang wen hui on 13-6-28.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

/**
 We have three logging levels such as info, warning, error.
 InfoLog(xx, ...) prints the normal information.
 Warning(xx, ...) prints the wraning information which user should pay attention to.
 Error(xx, ...) prints the error information before the Application may be crashed.
 
 Assert(xx) assert while the application occurs error.
 PrintMethodName() prints the method's name.
 The above macros print the information only in debug mode.
 */

//define log-levels
#define LOGLEVEL_INFO     5
#define OGLEVEL_WARNING   3
#define LOGLEVEL_ERROR    1

#ifndef MAXLOGLEVEL
#define MAXLOGLEVEL LOGLEVEL_ERROR
#endif

//#define LOGGING  //The Macro define is used for trace debug info while running a release or distribution version.

#ifdef __DISTRIBUTION_EXTERN__
#undef DEBUG
#endif

//#undef DEBUG
// ignores logging levels.
#ifdef DEBUG
#define Print(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#elif defined (LOGGING)
#define Print(xx, ...)  {\
if(globalLoggingEnabled)\
NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);\
}
#else
#define Print(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

// the three Log-levels compares to max log-level.
#if LOGLEVEL_ERROR <= MAXLOGLEVEL
#define Error(xx, ...)  Print(xx, ##__VA_ARGS__)
#else
#define Error(xx, ...)  ((void)0)
#endif // #if LOGLEVEL_ERROR <= MAXLOGLEVEL

#if LOGLEVEL_WARNING <= MAXLOGLEVEL
#define Warning(xx, ...)  Print(xx, ##__VA_ARGS__)
#else
#define Warning(xx, ...)  ((void)0)
#endif // #if LOGLEVEL_WARNING <= MAXLOGLEVEL

#if LOGLEVEL_INFO <= MAXLOGLEVEL
#define InfoLog(xx, ...)  Print(xx, ##__VA_ARGS__)
#else
#define InfoLog(xx, ...)  ((void)0)
#endif // #if LOGLEVEL_INFO <= MAXLOGLEVEL

// Prints the current method's name.
#if LOGLEVEL_INFO <= MAXLOGLEVEL
#define PrintMethodName() Print()
#else
#define PrintMethodName() ((void)0)
#endif // #if LOGLEVEL_INFO <= MAXLOGLEVEL
// Debug-only assertions.
#ifdef DEBUG

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR

int IsInDebugger();

#define Assert(xx) { if (!(xx)) { Print(@"Assert: %s", #xx); \
if (IsInDebugger()) { __asm__("int $3\n" : : ); }; } } ((void)0)

#else
#define Assert(xx) { if (!(xx)) { Print(@"Assert: %s", #xx); NSAssert(NO, @"STOPPED!");} } ((void)0)
#endif // #if TARGET_IPHONE_SIMULATOR

#else
#define Assert(xx) ((void)0)
#endif // #ifdef DEBUG

