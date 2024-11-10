#pragma once

#include <vector>

#include "../util/geo.h"
#include "../util/types.h"

namespace st {
struct Waypoint {
    Position pos;
    u8 speed;
};

struct Mission {
    std::vector<Waypoint> waypoints;
};

}  // namespace st