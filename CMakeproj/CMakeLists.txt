project(helloWorld)  # 项目名称

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 添加头文件搜索路径
include_directories(include)

# 寻找 ./src 下面所有 .cpp为后缀的源文件，并且保存到 SRC变量里面
file(GLOB_RECURSE SRC ./src/*.cpp)

# 编译SRC变量存储的源文件，编译生成目表文件名为hello
add_executable(hello ${SRC})
