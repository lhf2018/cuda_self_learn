cmake_minimum_required(VERSION 3.23)
project(cuda_learn CUDA)

set(CMAKE_CUDA_STANDARD 14)

add_executable(cuda_learn start/main.cu)

set_target_properties(cuda_learn PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)

file (GLOB_RECURSE files *.cu)
foreach (file ${files})
    string(REGEX REPLACE ".+/(.+)\\..*" "\\1" exe ${file})
    add_executable (${exe} ${file})
    message (\ \ \ \ --\ src/${exe}.cu\ will\ be\ compiled\ to\ bin/${exe})
endforeach ()