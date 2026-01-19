# Disable in-source builds to prevent source tree corruption.
if ("${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
	message(FATAL_ERROR "FATAL: Build directory cannot be the same as source directory.")
endif()

cmake_minimum_required(VERSION 3.21)

set(CMAKE_MODULE_PATH
	${CMAKE_MODULE_PATH}
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/"
)

project(ari LANGUAGES CXX)

if (NOT CMAKE_EXPORT_COMPILE_COMMANDS)
	set(CMAKE_EXPORT_COMPILE_COMMANDS "YES" CACHE STRING "" FORCE)
endif()

add_library(compiler_flags INTERFACE)

target_compile_features(compiler_flags INTERFACE cxx_std_20)
target_compile_options(compiler_flags INTERFACE "-Wall;-Wextra;-Wpedantic;-Werror")

include(FetchContent)
find_package(imgui)
find_package(implot)
find_package(implot3d)

FetchContent_Declare(
	Sleipnir
	GIT_REPOSITORY https://github.com/SleipnirGroup/Sleipnir.git
	GIT_TAG 72fb246
)

FetchContent_MakeAvailable(Sleipnir)

file(GLOB_RECURSE arilib_src "${CMAKE_CURRENT_SOURCE_DIR}/src/cpp/*.cpp")
file(GLOB_RECURSE arilib_inc "${CMAKE_CURRENT_SOURCE_DIR}/src/include/*.h")

if (arilib_src)
	add_library(arilib STATIC)
else()
	add_library(arilib INTERFACE)
endif()

target_sources(
	arilib
	PRIVATE
		${arilib_src}
	PUBLIC
		FILE_SET HEADERS
		BASE_DIRS
			${CMAKE_CURRENT_SOURCE_DIRECTORY}/src/include/
)

if (arilib_src)
	target_link_libraries(arilib PUBLIC compiler_flags Sleipnir)
else()
	target_link_libraries(arilib INTERFACE compiler_flags Sleipnir)
endif()

add_executable(analysis)

file(GLOB_RECURSE analysis_src "${CMAKE_CURRENT_SOURCE_DIR}/analysis/cpp/*.cpp")

target_sources(
	analysis
	PRIVATE
		${analysis_src}
	PRIVATE
		FILE_SET HEADERS
		BASE_DIRS
			${CMAKE_CURRENT_SOURCE_DIRECTORY}/analysis/include/
)

target_link_libraries(analysis PRIVATE compiler_flags arilib imgui implot implot3d)

add_executable(benchmark)

file(GLOB_RECURSE benchmark_src "${CMAKE_CURRENT_SOURCE_DIR}/benchmark/cpp/*.cpp")

target_sources(
	benchmark
	PRIVATE
		${benchmark_src}
	PRIVATE
		FILE_SET HEADERS
		BASE_DIRS
			${CMAKE_CURRENT_SOURCE_DIRECTORY}/benchmark/include/
)

target_link_libraries(benchmark PUBLIC compiler_flags arilib)
