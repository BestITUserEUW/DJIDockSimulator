#include "movement_emulator.h"

#include <cmath>
#include <doctest/doctest.h>

namespace st {
namespace {

using Vec3 = std::array<double, 3>;

auto GetDistance(const Vec3& d) -> double { return std::sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]); }

auto GetDiff(const Position& src, const Position& dest) -> Vec3 {
    double d_lat = dest.latitude - src.latitude;
    double d_lon = dest.longitude - src.longitude;
    double d_alt = dest.altitude - src.altitude;
    return {d_lat, d_lon, d_alt};
};

}  // namespace

MovementEmulator CreateMovementEmulator(Position src, Position dest, EmulatorSettings settings) {
    constexpr double kThreshold = 0.00001;  // Represenents 1 meter in degrees

    auto diff = GetDiff(src, dest);
    double distance = GetDistance(diff);

    while (distance > kThreshold) {
        for (auto& d : diff) {
            // Normalize and move based on speed and time
            d = (d / distance) * settings.speed * settings.time_step;
        }

        // Update our source by difference
        src.latitude += diff[0];
        src.longitude += diff[1];
        src.altitude += diff[2];

        // Update diff and distance based on new src
        diff = GetDiff(src, dest);
        distance = GetDistance(diff);

        co_yield src;
    }
    co_yield dest;
}

TEST_CASE("MovementEmulatorReachesDestination") {
    Position src{52.51450993568044, 13.237283428815944, 0, 0.0};
    Position dest{52.51491621248165, 13.24166080026626, 0, 30.0};

    auto runner = CreateMovementEmulator(src, dest, EmulatorSettings(3.0, 1.0));
    Position last_pos;
    for (auto&& position : runner) {
        last_pos = position;
    }
    CHECK_EQ(last_pos, dest);
}

}  // namespace st