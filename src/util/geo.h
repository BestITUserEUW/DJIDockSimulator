#pragma once

#include "types.h"

namespace st {

struct Position {
    double latitude;
    double longitude;
    double heading;
    double altitude;

    bool operator==(const Position& other) const = default;
};

}  // namespace st