##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=LockFreeQueue
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\LockFreeQueue"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=01/07/2015
CodeLitePath           :="d:\Program Files\CodeLite"
LinkerName             :=D:/MinGW-4.8.1/bin/g++.exe
SharedObjectLinkerName :=D:/MinGW-4.8.1/bin/g++.exe -shared -fPIC
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
ObjectsFileList        :="LockFreeQueue.txt"
PCHCompileFlags        :=
MakeDirCommand         :=makedir
RcCmpOptions           := 
RcCompilerName         :=D:/MinGW-4.8.1/bin/windres.exe
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
AR       := D:/MinGW-4.8.1/bin/ar.exe rcu
CXX      := D:/MinGW-4.8.1/bin/g++.exe
CC       := D:/MinGW-4.8.1/bin/gcc.exe
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := D:/MinGW-4.8.1/bin/as.exe


##
## User defined environment variables
##
CodeLiteDir:=d:\Program Files\CodeLite
Objects0=$(IntermediateDirectory)/main.cpp$(ObjectSuffix) $(IntermediateDirectory)/test_blocking_q.cpp$(ObjectSuffix) $(IntermediateDirectory)/test_lock_free_q.cpp$(ObjectSuffix) $(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

$(IntermediateDirectory)/.d:
	@$(MakeDirCommand) "./Debug"

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/main.cpp$(ObjectSuffix): main.cpp $(IntermediateDirectory)/main.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/LockFreeQueue/main.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.cpp$(DependSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/main.cpp$(DependSuffix) -MM "main.cpp"

$(IntermediateDirectory)/main.cpp$(PreprocessSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.cpp$(PreprocessSuffix) "main.cpp"

$(IntermediateDirectory)/test_blocking_q.cpp$(ObjectSuffix): test_blocking_q.cpp $(IntermediateDirectory)/test_blocking_q.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/LockFreeQueue/test_blocking_q.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/test_blocking_q.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/test_blocking_q.cpp$(DependSuffix): test_blocking_q.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/test_blocking_q.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/test_blocking_q.cpp$(DependSuffix) -MM "test_blocking_q.cpp"

$(IntermediateDirectory)/test_blocking_q.cpp$(PreprocessSuffix): test_blocking_q.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/test_blocking_q.cpp$(PreprocessSuffix) "test_blocking_q.cpp"

$(IntermediateDirectory)/test_lock_free_q.cpp$(ObjectSuffix): test_lock_free_q.cpp $(IntermediateDirectory)/test_lock_free_q.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/LockFreeQueue/test_lock_free_q.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/test_lock_free_q.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/test_lock_free_q.cpp$(DependSuffix): test_lock_free_q.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/test_lock_free_q.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/test_lock_free_q.cpp$(DependSuffix) -MM "test_lock_free_q.cpp"

$(IntermediateDirectory)/test_lock_free_q.cpp$(PreprocessSuffix): test_lock_free_q.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/test_lock_free_q.cpp$(PreprocessSuffix) "test_lock_free_q.cpp"

$(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(ObjectSuffix): test_lock_free_single_producer_q.cpp $(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/LockFreeQueue/test_lock_free_single_producer_q.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(DependSuffix): test_lock_free_single_producer_q.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(DependSuffix) -MM "test_lock_free_single_producer_q.cpp"

$(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(PreprocessSuffix): test_lock_free_single_producer_q.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/test_lock_free_single_producer_q.cpp$(PreprocessSuffix) "test_lock_free_single_producer_q.cpp"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


