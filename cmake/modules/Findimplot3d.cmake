if (NOT imgui_FOUND)
	find_package(imgui REQUIRED)
endif()

include(FetchContent)
FetchContent_Declare(
	implot3d
	GIT_REPOSITORY https://github.com/brenocq/implot3d.git
	GIT_TAG v0.3
	GIT_PROGRESS TRUE
)

FetchContent_MakeAvailable(implot)

file(GLOB implot3d_include ${implot_SOURCE_DIR}/*.h)
file(GLOB implot3d_src ${implot_SOURCE_DIR}/*.cpp)

add_library(implot3d STATIC)

target_sources(
	implot3d
	PUBLIC
		FILE_SET HEADERS
		BASE_DIRS
			${implot3d_SOURCE_DIR}
	PRIVATE
		${implot3d_src}
)

target_link_libraries(implot3d PUBLIC imgui)

# TODO: Implement the rest of the variables.
set(implot3d_FOUND TRUE)
