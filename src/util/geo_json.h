#pragma once

#include <vector>
#include <array>

#include "types.h"

namespace st {
struct Geometry {
    using Coordinate = std::array<float, 2>;
    using Polygon = std::vector<Coordinate>;
    using Polygons = std::array<Polygon, 1>;

    enum class Type { Polygon };

    Type type;
    Polygons coordinates;
};

struct Geofence {
    enum class FenceType { dfence, nfz };
    enum class Type { Feature };

    struct Properties {
        int radius;
        bool enable;
    };

    string id;
    Type type;
    FenceType geofence_type;
    Geometry geometry;
    Properties properties;
};

struct GeofenceCollection {
    enum class Type { FeatureCollection };

    Type type;
    std::vector<Geofence> features;
};

auto CreateCoordinate(float latitude, float longitude) -> Geometry::Coordinate {
    return Geometry::Coordinate{latitude, longitude};
}

}  // namespace st