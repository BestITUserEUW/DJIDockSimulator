#pragma once

#include <generator>

#include "../util/geo.h"

namespace st {
using MovementEmulator = std::generator<Position>;

struct EmulatorSettings {
    double speed;  // Speed in ms. Would be cool if we could have something like chrono but with ms kmh knots
    double time_step;
};

MovementEmulator CreateMovementEmulator(Position src, Position dest, EmulatorSettings settings);
}  // namespace st