##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=extern_cpp
ConfigurationName      :=Debug
WorkspacePath          :=/Users/ac/Desktop/example
ProjectPath            :=/Users/ac/Desktop/example/extern_cpp
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=austin chen
Date                   :=29/08/2018
CodeLitePath           :="/Users/ac/Library/Application Support/codelite"
LinkerName             :=/usr/bin/g++
SharedObjectLinkerName :=/usr/bin/g++ -dynamiclib -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.i
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
ObjectsFileList        :="extern_cpp.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
IncludePCH             := 
RcIncludePath          := 
Libs                   := 
ArLibs                 :=  
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := /usr/bin/ar rcu
CXX      := /usr/bin/g++
CC       := /usr/bin/gcc
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := /usr/bin/as


##
## User defined environment variables
##
CodeLiteDir:=/Applications/codelite.app/Contents/SharedSupport/
Objects0=$(IntermediateDirectory)/main.cpp$(ObjectSuffix) $(IntermediateDirectory)/foo.cc$(ObjectSuffix) $(IntermediateDirectory)/f1.cc$(ObjectSuffix) $(IntermediateDirectory)/fc.cc$(ObjectSuffix) $(IntermediateDirectory)/fn.c$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild MakeIntermediateDirs
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

MakeIntermediateDirs:
	@test -d ./Debug || $(MakeDirCommand) ./Debug


$(IntermediateDirectory)/.d:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/main.cpp$(ObjectSuffix): main.cpp $(IntermediateDirectory)/main.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/Users/ac/Desktop/example/extern_cpp/main.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.cpp$(DependSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/main.cpp$(DependSuffix) -MM main.cpp

$(IntermediateDirectory)/main.cpp$(PreprocessSuffix): main.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.cpp$(PreprocessSuffix) main.cpp

$(IntermediateDirectory)/foo.cc$(ObjectSuffix): foo.cc $(IntermediateDirectory)/foo.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/Users/ac/Desktop/example/extern_cpp/foo.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/foo.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/foo.cc$(DependSuffix): foo.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/foo.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/foo.cc$(DependSuffix) -MM foo.cc

$(IntermediateDirectory)/foo.cc$(PreprocessSuffix): foo.cc
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/foo.cc$(PreprocessSuffix) foo.cc

$(IntermediateDirectory)/f1.cc$(ObjectSuffix): f1.cc $(IntermediateDirectory)/f1.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/Users/ac/Desktop/example/extern_cpp/f1.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/f1.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/f1.cc$(DependSuffix): f1.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/f1.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/f1.cc$(DependSuffix) -MM f1.cc

$(IntermediateDirectory)/f1.cc$(PreprocessSuffix): f1.cc
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/f1.cc$(PreprocessSuffix) f1.cc

$(IntermediateDirectory)/fc.cc$(ObjectSuffix): fc.cc $(IntermediateDirectory)/fc.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/Users/ac/Desktop/example/extern_cpp/fc.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/fc.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/fc.cc$(DependSuffix): fc.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/fc.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/fc.cc$(DependSuffix) -MM fc.cc

$(IntermediateDirectory)/fc.cc$(PreprocessSuffix): fc.cc
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/fc.cc$(PreprocessSuffix) fc.cc

$(IntermediateDirectory)/fn.c$(ObjectSuffix): fn.c $(IntermediateDirectory)/fn.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/ac/Desktop/example/extern_cpp/fn.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/fn.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/fn.c$(DependSuffix): fn.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/fn.c$(ObjectSuffix) -MF$(IntermediateDirectory)/fn.c$(DependSuffix) -MM fn.c

$(IntermediateDirectory)/fn.c$(PreprocessSuffix): fn.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/fn.c$(PreprocessSuffix) fn.c


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


