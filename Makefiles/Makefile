.PHONY: 01 01_obj 01_obj_exe_run 02 02_obj_exe_run 03 03_obj_exe_run clean

GCC = gcc
NVCC = nvcc
CUDA_FLAGS = -arch=sm_86

# 编译并运行 01.c
01:
	@$(GCC) -o 01 01.c

# 编译 01.c 为目标文件
01_obj:
	@$(GCC) -c 01.c -o 01.o

# 编译并运行 01 可执行文件
01_obj_exe_run: 01_obj
	@$(GCC) 01.o -o 01
	@./01
	@echo "Execution result of 01.c: "
	@./01 # 显示执行结果

# 编译并运行 02.c
02:
	@$(GCC) -o 02 02.c

# 编译 02.c 为目标文件
02_obj:
	@$(GCC) -c 02.c -o 02.o

# 编译并运行 02 可执行文件
02_obj_exe_run: 02_obj
	@$(GCC) 02.o -o 02
	@./02
	@echo "Execution result of 02.c: "
	@./02 # 显示执行结果

# 编译并运行 03.cu (CUDA)
03:
	@$(NVCC) $(CUDA_FLAGS) -o 03_cu 03.cu

# 编译 03.cu 为目标文件
03_obj:
	@$(NVCC) $(CUDA_FLAGS) -c 03.cu -o 03.o

# 编译并运行 03_cu 可执行文件
03_obj_exe_run: 03_obj
	@$(NVCC) $(CUDA_FLAGS) 03.o -o 03_cu
	@./03_cu
	@echo "Execution result of 03.cu: "
	@./03_cu # 显示执行结果

# 清理所有生成的文件
clean: 
	rm -f 01 02 03_cu *.o
