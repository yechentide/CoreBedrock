//
// Created by yechentide on 2026/07/19
//

#ifndef CBImageEncoder_h
#define CBImageEncoder_h

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct CBImageEncoder CBImageEncoder;

CBImageEncoder * _Nullable CBImageEncoderCreatePNG(
    const char * _Nonnull path,
    int32_t width,
    int32_t height,
    char * _Nullable errorMessage,
    size_t errorMessageCapacity
);

CBImageEncoder * _Nullable CBImageEncoderCreateJPEG(
    const char * _Nonnull path,
    int32_t width,
    int32_t height,
    int32_t quality,
    uint8_t backgroundRed,
    uint8_t backgroundGreen,
    uint8_t backgroundBlue,
    char * _Nullable errorMessage,
    size_t errorMessageCapacity
);

bool CBImageEncoderWriteRows(
    CBImageEncoder * _Nonnull encoder,
    const uint8_t * _Nonnull rgbaBytes,
    size_t dataLength,
    size_t bytesPerRow,
    int32_t rowCount,
    char * _Nullable errorMessage,
    size_t errorMessageCapacity
);

bool CBImageEncoderFinish(
    CBImageEncoder * _Nonnull encoder,
    char * _Nullable errorMessage,
    size_t errorMessageCapacity
);

int64_t CBImageEncoderBytesWritten(CBImageEncoder * _Nonnull encoder);
void CBImageEncoderDestroy(CBImageEncoder * _Nullable encoder);

#ifdef __cplusplus
}
#endif

#endif
