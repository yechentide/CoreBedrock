//
// Created by yechentide on 2026/07/19
//

#include "CBImageEncoder.h"

#include <stdio.h>
#include <jpeglib.h>
#include <TargetConditionals.h>
#if !TARGET_OS_OSX
#include <png.h>
#else
#include <string.h>
#include <zlib.h>
#endif
#include <setjmp.h>
#include <stdlib.h>

typedef enum CBImageEncoderKind {
    CBImageEncoderKindPNG,
    CBImageEncoderKindJPEG,
} CBImageEncoderKind;

typedef struct CBJPEGErrorManager {
    struct jpeg_error_mgr base;
    jmp_buf jumpBuffer;
    char message[JMSG_LENGTH_MAX];
} CBJPEGErrorManager;

struct CBImageEncoder {
    CBImageEncoderKind kind;
    FILE *file;
    int32_t width;
    int32_t height;
    int32_t rowsWritten;
    bool finished;
#if !TARGET_OS_OSX
    png_structp png;
    png_infop pngInfo;
#else
    z_stream pngStream;
    uint8_t *pngRow;
#endif
    struct jpeg_compress_struct jpeg;
    CBJPEGErrorManager jpegError;
    uint8_t *jpegRow;
    uint8_t backgroundRed;
    uint8_t backgroundGreen;
    uint8_t backgroundBlue;
};

#if TARGET_OS_OSX
static void CBWriteBigEndian32(uint8_t bytes[4], uint32_t value) {
    bytes[0] = (uint8_t)(value >> 24);
    bytes[1] = (uint8_t)(value >> 16);
    bytes[2] = (uint8_t)(value >> 8);
    bytes[3] = (uint8_t)value;
}

static bool CBWritePNGChunk(
    CBImageEncoder *encoder,
    const char type[4],
    const uint8_t *data,
    uint32_t length
) {
    uint8_t lengthBytes[4];
    CBWriteBigEndian32(lengthBytes, length);
    if (fwrite(lengthBytes, 1, 4, encoder->file) != 4
        || fwrite(type, 1, 4, encoder->file) != 4
        || (length > 0 && fwrite(data, 1, length, encoder->file) != length)) {
        return false;
    }
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, (const Bytef *)type, 4);
    if (length > 0) {
        crc = crc32(crc, data, length);
    }
    uint8_t crcBytes[4];
    CBWriteBigEndian32(crcBytes, (uint32_t)crc);
    return fwrite(crcBytes, 1, 4, encoder->file) == 4;
}

static bool CBWritePNGDeflateOutput(CBImageEncoder *encoder, int flush) {
    uint8_t output[64 * 1024];
    do {
        encoder->pngStream.next_out = output;
        encoder->pngStream.avail_out = (uInt)sizeof(output);
        int result = deflate(&encoder->pngStream, flush);
        if (result != Z_OK && result != Z_STREAM_END) {
            return false;
        }
        uint32_t produced = (uint32_t)(sizeof(output) - encoder->pngStream.avail_out);
        if (produced > 0 && !CBWritePNGChunk(encoder, "IDAT", output, produced)) {
            return false;
        }
        if (result == Z_STREAM_END) {
            return true;
        }
    } while (encoder->pngStream.avail_in > 0 || flush == Z_FINISH);
    return true;
}
#endif

static void CBSetError(char *message, size_t capacity, const char *value) {
    if (message == NULL || capacity == 0) {
        return;
    }
    snprintf(message, capacity, "%s", value == NULL ? "Image encoding failed." : value);
}

static void CBJPEGErrorExit(j_common_ptr info) {
    CBJPEGErrorManager *manager = (CBJPEGErrorManager *)info->err;
    (*info->err->format_message)(info, manager->message);
    longjmp(manager->jumpBuffer, 1);
}

static CBImageEncoder *CBAllocateEncoder(
    const char *path,
    int32_t width,
    int32_t height,
    char *errorMessage,
    size_t errorMessageCapacity
) {
    if (width <= 0 || height <= 0) {
        CBSetError(errorMessage, errorMessageCapacity, "Invalid image dimensions.");
        return NULL;
    }
    CBImageEncoder *encoder = calloc(1, sizeof(CBImageEncoder));
    if (encoder == NULL) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to allocate image encoder.");
        return NULL;
    }
    encoder->file = fopen(path, "wb");
    if (encoder->file == NULL) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to create the output file.");
        free(encoder);
        return NULL;
    }
    encoder->width = width;
    encoder->height = height;
    return encoder;
}

CBImageEncoder *CBImageEncoderCreatePNG(
    const char *path,
    int32_t width,
    int32_t height,
    char *errorMessage,
    size_t errorMessageCapacity
) {
    CBImageEncoder *encoder = CBAllocateEncoder(
        path, width, height, errorMessage, errorMessageCapacity
    );
    if (encoder == NULL) {
        return NULL;
    }
    encoder->kind = CBImageEncoderKindPNG;
#if !TARGET_OS_OSX
    encoder->png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (encoder->png == NULL) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to initialize PNG encoding.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    encoder->pngInfo = png_create_info_struct(encoder->png);
    if (encoder->pngInfo == NULL) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to initialize PNG metadata.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    if (setjmp(png_jmpbuf(encoder->png))) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to begin PNG encoding.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    png_init_io(encoder->png, encoder->file);
    png_set_IHDR(
        encoder->png,
        encoder->pngInfo,
        (png_uint_32)width,
        (png_uint_32)height,
        8,
        PNG_COLOR_TYPE_RGBA,
        PNG_INTERLACE_NONE,
        PNG_COMPRESSION_TYPE_DEFAULT,
        PNG_FILTER_TYPE_DEFAULT
    );
    png_write_info(encoder->png, encoder->pngInfo);
#else
    static const uint8_t signature[8] = {137, 80, 78, 71, 13, 10, 26, 10};
    uint8_t header[13] = {0};
    CBWriteBigEndian32(header, (uint32_t)width);
    CBWriteBigEndian32(header + 4, (uint32_t)height);
    header[8] = 8;
    header[9] = 6;
    if (fwrite(signature, 1, sizeof(signature), encoder->file) != sizeof(signature)
        || !CBWritePNGChunk(encoder, "IHDR", header, sizeof(header))) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to begin PNG encoding.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    if (deflateInit(&encoder->pngStream, Z_DEFAULT_COMPRESSION) != Z_OK) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to initialize PNG compression.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    encoder->pngRow = malloc((size_t)width * 4 + 1);
    if (encoder->pngRow == NULL) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to allocate a PNG scanline.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
#endif
    return encoder;
}

CBImageEncoder *CBImageEncoderCreateJPEG(
    const char *path,
    int32_t width,
    int32_t height,
    int32_t quality,
    uint8_t backgroundRed,
    uint8_t backgroundGreen,
    uint8_t backgroundBlue,
    char *errorMessage,
    size_t errorMessageCapacity
) {
    CBImageEncoder *encoder = CBAllocateEncoder(
        path, width, height, errorMessage, errorMessageCapacity
    );
    if (encoder == NULL) {
        return NULL;
    }
    encoder->kind = CBImageEncoderKindJPEG;
    encoder->backgroundRed = backgroundRed;
    encoder->backgroundGreen = backgroundGreen;
    encoder->backgroundBlue = backgroundBlue;
    encoder->jpeg.err = jpeg_std_error(&encoder->jpegError.base);
    encoder->jpegError.base.error_exit = CBJPEGErrorExit;
    if (setjmp(encoder->jpegError.jumpBuffer)) {
        CBSetError(errorMessage, errorMessageCapacity, encoder->jpegError.message);
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    jpeg_create_compress(&encoder->jpeg);
    jpeg_stdio_dest(&encoder->jpeg, encoder->file);
    encoder->jpeg.image_width = (JDIMENSION)width;
    encoder->jpeg.image_height = (JDIMENSION)height;
    encoder->jpeg.input_components = 3;
    encoder->jpeg.in_color_space = JCS_RGB;
    jpeg_set_defaults(&encoder->jpeg);
    jpeg_set_quality(&encoder->jpeg, quality, TRUE);
    jpeg_start_compress(&encoder->jpeg, TRUE);
    encoder->jpegRow = malloc((size_t)width * 3);
    if (encoder->jpegRow == NULL) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to allocate a JPEG scanline.");
        CBImageEncoderDestroy(encoder);
        return NULL;
    }
    return encoder;
}

bool CBImageEncoderWriteRows(
    CBImageEncoder *encoder,
    const uint8_t *rgbaBytes,
    size_t dataLength,
    size_t bytesPerRow,
    int32_t rowCount,
    char *errorMessage,
    size_t errorMessageCapacity
) {
    if (encoder == NULL || rgbaBytes == NULL || encoder->finished || rowCount < 0) {
        CBSetError(errorMessage, errorMessageCapacity, "Invalid image row data.");
        return false;
    }
    size_t minimumBytesPerRow = (size_t)encoder->width * 4;
    if (rowCount > encoder->height - encoder->rowsWritten
        || bytesPerRow < minimumBytesPerRow
        || (size_t)rowCount > dataLength / bytesPerRow) {
        CBSetError(errorMessage, errorMessageCapacity, "Invalid image row data.");
        return false;
    }
    if (encoder->kind == CBImageEncoderKindPNG) {
#if !TARGET_OS_OSX
        if (setjmp(png_jmpbuf(encoder->png))) {
            CBSetError(errorMessage, errorMessageCapacity, "PNG row encoding failed.");
            return false;
        }
        for (int32_t row = 0; row < rowCount; row++) {
            png_bytep pointer = (png_bytep)(rgbaBytes + (size_t)row * bytesPerRow);
            png_write_row(encoder->png, pointer);
        }
#else
        for (int32_t row = 0; row < rowCount; row++) {
            encoder->pngRow[0] = 0;
            memcpy(
                encoder->pngRow + 1,
                rgbaBytes + (size_t)row * bytesPerRow,
                (size_t)encoder->width * 4
            );
            encoder->pngStream.next_in = encoder->pngRow;
            encoder->pngStream.avail_in = (uInt)((size_t)encoder->width * 4 + 1);
            if (!CBWritePNGDeflateOutput(encoder, Z_NO_FLUSH)) {
                CBSetError(errorMessage, errorMessageCapacity, "PNG row encoding failed.");
                return false;
            }
        }
#endif
    } else {
        if (setjmp(encoder->jpegError.jumpBuffer)) {
            CBSetError(errorMessage, errorMessageCapacity, encoder->jpegError.message);
            return false;
        }
        for (int32_t row = 0; row < rowCount; row++) {
            const uint8_t *source = rgbaBytes + (size_t)row * bytesPerRow;
            for (int32_t x = 0; x < encoder->width; x++) {
                const uint8_t *pixel = source + (size_t)x * 4;
                uint16_t alpha = pixel[3];
                uint16_t inverseAlpha = 255 - alpha;
                encoder->jpegRow[(size_t)x * 3] = (uint8_t)(
                    (pixel[0] * alpha + encoder->backgroundRed * inverseAlpha + 127) / 255
                );
                encoder->jpegRow[(size_t)x * 3 + 1] = (uint8_t)(
                    (pixel[1] * alpha + encoder->backgroundGreen * inverseAlpha + 127) / 255
                );
                encoder->jpegRow[(size_t)x * 3 + 2] = (uint8_t)(
                    (pixel[2] * alpha + encoder->backgroundBlue * inverseAlpha + 127) / 255
                );
            }
            JSAMPROW pointer = encoder->jpegRow;
            if (jpeg_write_scanlines(&encoder->jpeg, &pointer, 1) != 1) {
                CBSetError(errorMessage, errorMessageCapacity, "JPEG row encoding failed.");
                return false;
            }
        }
    }
    encoder->rowsWritten += rowCount;
    return true;
}

bool CBImageEncoderFinish(
    CBImageEncoder *encoder,
    char *errorMessage,
    size_t errorMessageCapacity
) {
    if (encoder == NULL || encoder->finished || encoder->rowsWritten != encoder->height) {
        CBSetError(errorMessage, errorMessageCapacity, "The image has incomplete rows.");
        return false;
    }
    if (encoder->kind == CBImageEncoderKindPNG) {
#if !TARGET_OS_OSX
        if (setjmp(png_jmpbuf(encoder->png))) {
            CBSetError(errorMessage, errorMessageCapacity, "Unable to finalize the PNG image.");
            return false;
        }
        png_write_end(encoder->png, encoder->pngInfo);
#else
        encoder->pngStream.next_in = Z_NULL;
        encoder->pngStream.avail_in = 0;
        if (!CBWritePNGDeflateOutput(encoder, Z_FINISH)
            || !CBWritePNGChunk(encoder, "IEND", NULL, 0)) {
            CBSetError(errorMessage, errorMessageCapacity, "Unable to finalize the PNG image.");
            return false;
        }
#endif
    } else {
        if (setjmp(encoder->jpegError.jumpBuffer)) {
            CBSetError(errorMessage, errorMessageCapacity, encoder->jpegError.message);
            return false;
        }
        jpeg_finish_compress(&encoder->jpeg);
    }
    if (fflush(encoder->file) != 0 || ferror(encoder->file)) {
        CBSetError(errorMessage, errorMessageCapacity, "Unable to flush the image file.");
        return false;
    }
    encoder->finished = true;
    return true;
}

int64_t CBImageEncoderBytesWritten(CBImageEncoder *encoder) {
    if (encoder == NULL || encoder->file == NULL) {
        return 0;
    }
    fflush(encoder->file);
    long position = ftell(encoder->file);
    return position < 0 ? 0 : (int64_t)position;
}

void CBImageEncoderDestroy(CBImageEncoder *encoder) {
    if (encoder == NULL) {
        return;
    }
    if (encoder->kind == CBImageEncoderKindPNG
#if !TARGET_OS_OSX
        && encoder->png != NULL
#endif
    ) {
#if !TARGET_OS_OSX
        png_destroy_write_struct(
            &encoder->png,
            encoder->pngInfo == NULL ? NULL : &encoder->pngInfo
        );
#else
        if (encoder->pngStream.state != NULL) {
            deflateEnd(&encoder->pngStream);
        }
        free(encoder->pngRow);
#endif
    } else if (encoder->kind == CBImageEncoderKindJPEG && encoder->jpeg.mem != NULL) {
        jpeg_destroy_compress(&encoder->jpeg);
    }
    free(encoder->jpegRow);
    if (encoder->file != NULL) {
        fclose(encoder->file);
    }
    free(encoder);
}
