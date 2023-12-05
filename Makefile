# Non-volatile memory simulator
# Pre-release version, r131

target := nvsim

# define tool chain
CXX := g++
RM := rm -f

# define build options
# compile options
CXXFLAGS := -Wall
# link options
LDFLAGS :=
# link librarires
LDLIBS :=

# User-specified output directory, 把编译输出的.o放到output/路径下，输出的.exe文件还是放在根目录下
OUTPUT_DIR := output/

# construct list of .cpp and their corresponding .o and .d files
SRC := $(wildcard *.cpp)
INC := 
DBG :=
# OBJ := $(SRC:.cpp=.o)
OBJ := $(addprefix $(OUTPUT_DIR), $(SRC:.cpp=.o))
DEP := Makefile.dep

$(shell mkdir -p $(OUTPUT_DIR))

#create_folder:
#    @if [ ! -d "$(OUTPUT_DIR)" ]; then \
#        mkdir -p "$(OUTPUT_DIR)"; \
#    fi

# file disambiguity is achieved via the .PHONY directive
.PHONY : all clean dbg


all : $(target)

dbg: DBG += -ggdb -g
dbg: $(target)

$(target) : $(OBJ)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

clean :
	$(RM) $(target) $(DEP) $(OBJ)

$(OUTPUT_DIR)%.o : %.cpp
	$(CXX) $(CXXFLAGS) $(DBG) $(INC) -c $< -o $@
#.cpp.o :
#	$(CXX) $(CXXFLAGS) $(DBG) $(INC) -c $< -o $@

depend $(DEP):
	@echo Makefile - creating dependencies for: $(SRC)
#	@$(RM) $(DEP)
	@$(CXX) -E -MM $(INC) $(SRC) >> $(DEP)

ifeq (,$(findstring clean,$(MAKECMDGOALS)))
-include $(DEP)
endif

# clean:
# 	$(RM) $(DEP)