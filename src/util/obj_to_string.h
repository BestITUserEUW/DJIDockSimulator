#pragma once

#include <format>

#include <rfl/json/write.hpp>

namespace st {
template <typename T>
auto ObjectToString(const T& obj) -> std::string {
    return std::format("{}({})", rfl::type_name_t<T>().str(), rfl::json::write(obj, rfl::json::pretty));
}
}  // namespace st