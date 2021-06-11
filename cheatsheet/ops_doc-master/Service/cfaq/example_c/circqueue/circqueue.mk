##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=circqueue
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\circqueue"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=05/15/14
CodeLitePath           :="D:\Program Files\CodeLite"
LinkerName             :=gcc
SharedObjectLinkerName :=gcc -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.o.i
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
ObjectsFileList        :="circqueue.txt"
PCHCompileFlags        :=
MakeDirCommand         :=makedir
RcCmpOptions           := 
RcCompilerName         :=windres
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
AR       := ar rcus
CXX      := gcc
CC       := gcc
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall -std=c99 $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=D:\Program Files\CodeLite
UNIT_TEST_PP_SRC_DIR:=d:\UnitTest++-1.3
Objects0=$(IntermediateDirectory)/circqueue$(ObjectSuffix) $(IntermediateDirectory)/circqueue_test$(ObjectSuffix) 



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
$(IntermediateDirectory)/circqueue$(ObjectSuffix): circqueue.c $(IntermediateDirectory)/circqueue$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/circqueue/circqueue.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/circqueue$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/circqueue$(DependSuffix): circqueue.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/circqueue$(ObjectSuffix) -MF$(IntermediateDirectory)/circqueue$(DependSuffix) -MM "circqueue.c"

$(IntermediateDirectory)/circqueue$(PreprocessSuffix): circqueue.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/circqueue$(PreprocessSuffix) "circqueue.c"

$(IntermediateDirectory)/circqueue_test$(ObjectSuffix): circqueue_test.c $(IntermediateDirectory)/circqueue_test$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/circqueue/circqueue_test.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/circqueue_test$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/circqueue_test$(DependSuffix): circqueue_test.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/circqueue_test$(ObjectSuffix) -MF$(IntermediateDirectory)/circqueue_test$(DependSuffix) -MM "circqueue_test.c"

$(IntermediateDirectory)/circqueue_test$(PreprocessSuffix): circqueue_test.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/circqueue_test$(PreprocessSuffix) "circqueue_test.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) $(IntermediateDirectory)/circqueue$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/circqueue$(DependSuffix)
	$(RM) $(IntermediateDirectory)/circqueue$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/circqueue_test$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/circqueue_test$(DependSuffix)
	$(RM) $(IntermediateDirectory)/circqueue_test$(PreprocessSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile).exe
	$(RM) "../.build-debug/circqueue"


