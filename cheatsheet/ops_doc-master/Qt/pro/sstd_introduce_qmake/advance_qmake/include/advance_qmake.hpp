#pragma once

#include <chrono>
#include <cassert>
#include <fstream>
#include <iostream>
#include <type_traits>
#include <string_view>

using namespace std::string_view_literals;

#if __has_include(<filesystem>)

#include <filesystem>
namespace fs = std::filesystem;

#else

#include <experimental/filesystem>
namespace fs = std::experimental::filesystem;

#endif

template<typename T>
inline decltype(auto) streamFileName(const T & arg) {
    if constexpr (std::is_constructible_v< std::ifstream, const T & >) {
        return arg;
    } else if constexpr (std::is_constructible_v<std::ifstream, const std::wstring &>) {
        return arg.wstring();
    } else {
        return arg.string();
    }
}

inline auto getNow() {
    return std::chrono::duration_cast<std::chrono::seconds>(
        std::chrono::high_resolution_clock::now()
        .time_since_epoch()).count();
}
