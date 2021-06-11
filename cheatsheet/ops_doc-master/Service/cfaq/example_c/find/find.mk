##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=find
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\find"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=2013/1/21
CodeLitePath           :="d:\Program Files\CodeLite"
LinkerName             :=g++
SharedObjectLinkerName :=g++ -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.o.i
DebugSwitch            :=-gstab
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
ObjectsFileList        :="E:\data\example\find\find.txt"
PCHCompileFlags        :=
MakeDirCommand         :=makedir
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
IncludePCH             := 
RcIncludePath          := 
Libs                   := 
ArLibs                 :=  
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := g++
CC       := gcc
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)


##
## User defined environment variables
##
CodeLiteDir:=d:\Program Files\CodeLite
UNIT_TEST_PP_SRC_DIR:=d:\UnitTest++-1.3
Objects=$(IntermediateDirectory)/main$(ObjectSuffix) $(IntermediateDirectory)/BinarySearch$(ObjectSuffix) $(IntermediateDirectory)/container_of_main$(ObjectSuffix) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects) > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

$(IntermediateDirectory)/.d:
	@$(MakeDirCommand) "./Debug"

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/main$(ObjectSuffix): main.cpp $(IntermediateDirectory)/main$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/find/main.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main$(DependSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main$(ObjectSuffix) -MF$(IntermediateDirectory)/main$(DependSuffix) -MM "E:/data/example/find/main.cpp"

$(IntermediateDirectory)/main$(PreprocessSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main$(PreprocessSuffix) "E:/data/example/find/main.cpp"

$(IntermediateDirectory)/BinarySearch$(ObjectSuffix): BinarySearch.cc $(IntermediateDirectory)/BinarySearch$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/find/BinarySearch.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/BinarySearch$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/BinarySearch$(DependSuffix): BinarySearch.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/BinarySearch$(ObjectSuffix) -MF$(IntermediateDirectory)/BinarySearch$(DependSuffix) -MM "E:/data/example/find/BinarySearch.cc"

$(IntermediateDirectory)/BinarySearch$(PreprocessSuffix): BinarySearch.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/BinarySearch$(PreprocessSuffix) "E:/data/example/find/BinarySearch.cc"

$(IntermediateDirectory)/container_of_main$(ObjectSuffix): ../container_of/main.c $(IntermediateDirectory)/container_of_main$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/container_of/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/container_of_main$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/container_of_main$(DependSuffix): ../container_of/main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/container_of_main$(ObjectSuffix) -MF$(IntermediateDirectory)/container_of_main$(DependSuffix) -MM "E:/data/example/container_of/main.c"

$(IntermediateDirectory)/container_of_main$(PreprocessSuffix): ../container_of/main.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/container_of_main$(PreprocessSuffix) "E:/data/example/container_of/main.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) $(IntermediateDirectory)/main$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/main$(DependSuffix)
	$(RM) $(IntermediateDirectory)/main$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/BinarySearch$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/BinarySearch$(DependSuffix)
	$(RM) $(IntermediateDirectory)/BinarySearch$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/container_of_main$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/container_of_main$(DependSuffix)
	$(RM) $(IntermediateDirectory)/container_of_main$(PreprocessSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile).exe
	$(RM) "E:\data\example\.build-debug\find"


