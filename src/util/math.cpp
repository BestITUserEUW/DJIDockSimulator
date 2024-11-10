#include "math.h"

#include <doctest/doctest.h>

namespace st::math {
TEST_CASE("TestDegreesToRadians") {
    CHECK_EQ(Radians<double>(52.13245), 0.9098828996313179);
    CHECK_EQ(Radians<float>(52.13245F), 0.9098829F);
}
}  // namespace st::math