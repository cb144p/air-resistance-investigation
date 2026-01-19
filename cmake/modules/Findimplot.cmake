if (NOT imgui_FOUND)
	find_package(imgui REQUIRED)
endif()

include(FetchContent)
FetchContent_Declare(
	implot
	GIT_REPOSITORY https://github.com/epezent/implot
	GIT_TAG v0.17
	GIT_PROGRESS TRUE
)

FetchContent_MakeAvailable(implot)

file(GLOB implot_include ${implot_SOURCE_DIR}/*.h)
file(GLOB implot_src ${implot_SOURCE_DIR}/*.cpp)
message("${implot_src}")

add_library(implot STATIC)

target_sources(
	implot
	PUBLIC
		FILE_SET HEADERS
		BASE_DIRS
			${implot_SOURCE_DIR}
	PRIVATE
		${implot_src}
)

target_link_libraries(implot PUBLIC imgui)

# TODO: Implement the rest of the variables.
set(implot_FOUND TRUE)
