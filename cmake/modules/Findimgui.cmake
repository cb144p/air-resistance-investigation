# Build imgui with implot, glfw, and opengl.

# implot example does this
set(CMP0072 NEW)
if (NOT OpenGL_FOUND)
	find_package(OpenGL 3 REQUIRED)
endif()

set(GLFW_BUILD_DOCS OFF)
set(GLFW_INSTALL OFF)

include(FetchContent)
FetchContent_Declare(
	glfw
	GIT_REPOSITORY https://github.com/glfw/glfw
	GIT_TAG 3.4
	GIT_PROGRESS TRUE
)

FetchContent_Declare(
	imgui
	GIT_REPOSITORY https://github.com/ocornut/imgui
	GIT_TAG v1.92.5
	GIT_PROGRESS TRUE
	BUILD_COMMAND ""
	CONFIGURE_COMMAND ""
)

FetchContent_MakeAvailable(glfw imgui)
# Don't recurse here because we only want certain backends.
file(GLOB imgui_main_src ${imgui_SOURCE_DIR}/*.cpp)

add_library(imgui STATIC)

target_sources(
	imgui
	PUBLIC
		FILE_SET HEADERS
		BASE_DIRS
			${imgui_SOURCE_DIR}
	PUBLIC
		FILE_SET backendHeaders
		TYPE HEADERS
		BASE_DIRS
			${imgui_SOURCE_DIR}/backends
		FILES
			${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.h
			${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.h
	PRIVATE
		${imgui_main_src}
		${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.cpp
		${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
)

# Make imgui use 32 bit indexing.
target_compile_definitions(imgui PUBLIC "ImDrawIdx=unsigned int")
target_compile_features(imgui PUBLIC cxx_std_20)
target_link_libraries(imgui PUBLIC glfw OpenGL::GL)

# TODO: Implement the rest of the variables.
set(imgui_FOUND TRUE)
