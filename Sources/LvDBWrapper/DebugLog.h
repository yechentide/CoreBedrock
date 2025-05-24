//
// Created by yechentide on 2025/05/05
//

#pragma once

#import <Foundation/Foundation.h>

// To enable debug logging, add LVDB_DEBUG_LOG_ENABLED=1 to "Preprocessor Macros"
// in Xcode's Build Settings for the desired build configuration (e.g., Debug).
// For example: LVDB_DEBUG_LOG_ENABLED=1

#ifdef __cplusplus
extern "C" {
#endif

void DebugLog(NSString *format, ...);

#ifdef __cplusplus
}
#endif
