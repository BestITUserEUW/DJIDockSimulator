#pragma once

#include <type_traits>
#include <cmath>

namespace st::math {
namespace traits {

template <class T>
concept FloatingPoint = std::is_floating_point<T>::value;

}

template <traits::FloatingPoint T>
constexpr inline T Radians(T degrees) {
    return degrees * M_PI / 180.0;
}

}  // namespace st::math