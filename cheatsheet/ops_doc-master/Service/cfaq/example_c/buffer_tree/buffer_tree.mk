##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=buffer_tree
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\buffer_tree"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=2013/9/25
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
ObjectsFileList        :="buffer_tree.txt"
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
## AR, CXX, CC, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := gcc
CC       := gcc
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)


##
## User defined environment variables
##
CodeLiteDir:=D:\Program Files\CodeLite
UNIT_TEST_PP_SRC_DIR:=d:\UnitTest++-1.3
Objects0=$(IntermediateDirectory)/main$(ObjectSuffix) $(IntermediateDirectory)/buffered_tree$(ObjectSuffix) $(IntermediateDirectory)/redis-dict$(ObjectSuffix) $(IntermediateDirectory)/sds$(ObjectSuffix) 



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
$(IntermediateDirectory)/main$(ObjectSuffix): main.c $(IntermediateDirectory)/main$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/buffer_tree/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main$(DependSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main$(ObjectSuffix) -MF$(IntermediateDirectory)/main$(DependSuffix) -MM "main.c"

$(IntermediateDirectory)/main$(PreprocessSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main$(PreprocessSuffix) "main.c"

$(IntermediateDirectory)/buffered_tree$(ObjectSuffix): buffered_tree.c $(IntermediateDirectory)/buffered_tree$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/buffer_tree/buffered_tree.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/buffered_tree$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/buffered_tree$(DependSuffix): buffered_tree.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/buffered_tree$(ObjectSuffix) -MF$(IntermediateDirectory)/buffered_tree$(DependSuffix) -MM "buffered_tree.c"

$(IntermediateDirectory)/buffered_tree$(PreprocessSuffix): buffered_tree.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/buffered_tree$(PreprocessSuffix) "buffered_tree.c"

$(IntermediateDirectory)/redis-dict$(ObjectSuffix): redis-dict.c $(IntermediateDirectory)/redis-dict$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/buffer_tree/redis-dict.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/redis-dict$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/redis-dict$(DependSuffix): redis-dict.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/redis-dict$(ObjectSuffix) -MF$(IntermediateDirectory)/redis-dict$(DependSuffix) -MM "redis-dict.c"

$(IntermediateDirectory)/redis-dict$(PreprocessSuffix): redis-dict.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/redis-dict$(PreprocessSuffix) "redis-dict.c"

$(IntermediateDirectory)/sds$(ObjectSuffix): sds.c $(IntermediateDirectory)/sds$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/buffer_tree/sds.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/sds$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/sds$(DependSuffix): sds.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/sds$(ObjectSuffix) -MF$(IntermediateDirectory)/sds$(DependSuffix) -MM "sds.c"

$(IntermediateDirectory)/sds$(PreprocessSuffix): sds.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/sds$(PreprocessSuffix) "sds.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) $(IntermediateDirectory)/main$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/main$(DependSuffix)
	$(RM) $(IntermediateDirectory)/main$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/buffered_tree$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/buffered_tree$(DependSuffix)
	$(RM) $(IntermediateDirectory)/buffered_tree$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/redis-dict$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/redis-dict$(DependSuffix)
	$(RM) $(IntermediateDirectory)/redis-dict$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/sds$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/sds$(DependSuffix)
	$(RM) $(IntermediateDirectory)/sds$(PreprocessSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile).exe
	$(RM) "../.build-debug/buffer_tree"


