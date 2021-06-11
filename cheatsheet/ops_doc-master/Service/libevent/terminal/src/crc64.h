#pragma once
#include <stdint.h>
#include <unistd.h>

uint64_t crc64(uint8_t type, void *str, size_t len);
