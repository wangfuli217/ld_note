##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=bump_pointer_allocator
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\bump_pointer_allocator"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=12/06/13
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
ObjectsFileList        :="bump_pointer_allocator.txt"
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
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
CodeLiteDir:=D:\Program Files\CodeLite
UNIT_TEST_PP_SRC_DIR:=d:\UnitTest++-1.3
Objects0=$(IntermediateDirectory)/bpa$(ObjectSuffix) $(IntermediateDirectory)/testbpa$(ObjectSuffix) 



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
$(IntermediateDirectory)/bpa$(ObjectSuffix): bpa.c $(IntermediateDirectory)/bpa$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/bump_pointer_allocator/bpa.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/bpa$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/bpa$(DependSuffix): bpa.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/bpa$(ObjectSuffix) -MF$(IntermediateDirectory)/bpa$(DependSuffix) -MM "bpa.c"

$(IntermediateDirectory)/bpa$(PreprocessSuffix): bpa.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/bpa$(PreprocessSuffix) "bpa.c"

$(IntermediateDirectory)/testbpa$(ObjectSuffix): testbpa.c $(IntermediateDirectory)/testbpa$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/bump_pointer_allocator/testbpa.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/testbpa$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/testbpa$(DependSuffix): testbpa.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/testbpa$(ObjectSuffix) -MF$(IntermediateDirectory)/testbpa$(DependSuffix) -MM "testbpa.c"

$(IntermediateDirectory)/testbpa$(PreprocessSuffix): testbpa.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/testbpa$(PreprocessSuffix) "testbpa.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) $(IntermediateDirectory)/bpa$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/bpa$(DependSuffix)
	$(RM) $(IntermediateDirectory)/bpa$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/testbpa$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/testbpa$(DependSuffix)
	$(RM) $(IntermediateDirectory)/testbpa$(PreprocessSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile).exe
	$(RM) "../.build-debug/bump_pointer_allocator"


