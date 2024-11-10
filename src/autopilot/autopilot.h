#pragma once

#include <expected>
#include <atomic>

#include "../util/types.h"
#include "../util/geo_json.h"
#include "../util/synchonized.h"

#include "mission.h"
#include "movement_emulator.h"

namespace st {

enum class FlightMode : u8 { Standby, Mission, ReturnHome };
enum class LandedState : u8 { Takeoff, InAir, Landing };

struct MissionProgress {
    Waypoint waypoint;
    int waypoint_index;
};

class Autopilot {
public:
    Autopilot(const Position& home_pos);

    auto UpdloadMission(unique_ptr<Mission> mission) -> bool;
    auto UpdloadGeofence(unique_ptr<Geofence> geofence) -> bool;
    auto ExecuteMission() -> bool;
    auto ReturnHome() -> bool;
    auto PauseMission() -> bool;
    auto ContinueMission() -> bool;
    auto position() -> Position;
    auto flight_mode() -> FlightMode;
    auto landed_state() -> LandedState;
    auto mission_progress() -> MissionProgress;
    auto IsMissionPaused() -> bool;

private:
    std::atomic<FlightMode> flight_mode_;
    std::atomic<LandedState> landed_state_;
    synchronized<Position> position_;
    synchronized<MissionProgress> mission_progress_;
    unique_ptr<Mission> mission_;
    unique_ptr<Geofence> geofence_;
};
}  // namespace st