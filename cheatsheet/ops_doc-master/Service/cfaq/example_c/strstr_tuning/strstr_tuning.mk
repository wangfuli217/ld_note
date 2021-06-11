##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=strstr_tuning
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\strstr_tuning"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=09/01/14
CodeLitePath           :="D:\Program Files\CodeLite"
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
ObjectsFileList        :="strstr_tuning.txt"
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
CodeLiteDir:=D:\Program Files\CodeLite
UNIT_TEST_PP_SRC_DIR:=d:\UnitTest++-1.3
Objects0=$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IntermediateDirectory)/lstrlen.c$(ObjectSuffix) $(IntermediateDirectory)/lstrstr.c$(ObjectSuffix) $(IntermediateDirectory)/lstrstrsse.c$(ObjectSuffix) $(IntermediateDirectory)/strstr.c$(ObjectSuffix) $(IntermediateDirectory)/teststrstr.c$(ObjectSuffix) 



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
$(IntermediateDirectory)/main.c$(ObjectSuffix): main.c $(IntermediateDirectory)/main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/strstr_tuning/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.c$(DependSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/main.c$(DependSuffix) -MM "main.c"

$(IntermediateDirectory)/main.c$(PreprocessSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.c$(PreprocessSuffix) "main.c"

$(IntermediateDirectory)/lstrlen.c$(ObjectSuffix): lstrlen.c $(IntermediateDirectory)/lstrlen.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/strstr_tuning/lstrlen.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/lstrlen.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/lstrlen.c$(DependSuffix): lstrlen.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/lstrlen.c$(ObjectSuffix) -MF$(IntermediateDirectory)/lstrlen.c$(DependSuffix) -MM "lstrlen.c"

$(IntermediateDirectory)/lstrlen.c$(PreprocessSuffix): lstrlen.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/lstrlen.c$(PreprocessSuffix) "lstrlen.c"

$(IntermediateDirectory)/lstrstr.c$(ObjectSuffix): lstrstr.c $(IntermediateDirectory)/lstrstr.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/strstr_tuning/lstrstr.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/lstrstr.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/lstrstr.c$(DependSuffix): lstrstr.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/lstrstr.c$(ObjectSuffix) -MF$(IntermediateDirectory)/lstrstr.c$(DependSuffix) -MM "lstrstr.c"

$(IntermediateDirectory)/lstrstr.c$(PreprocessSuffix): lstrstr.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/lstrstr.c$(PreprocessSuffix) "lstrstr.c"

$(IntermediateDirectory)/lstrstrsse.c$(ObjectSuffix): lstrstrsse.c $(IntermediateDirectory)/lstrstrsse.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/strstr_tuning/lstrstrsse.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/lstrstrsse.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/lstrstrsse.c$(DependSuffix): lstrstrsse.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/lstrstrsse.c$(ObjectSuffix) -MF$(IntermediateDirectory)/lstrstrsse.c$(DependSuffix) -MM "lstrstrsse.c"

$(IntermediateDirectory)/lstrstrsse.c$(PreprocessSuffix): lstrstrsse.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/lstrstrsse.c$(PreprocessSuffix) "lstrstrsse.c"

$(IntermediateDirectory)/strstr.c$(ObjectSuffix): strstr.c $(IntermediateDirectory)/strstr.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/strstr_tuning/strstr.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/strstr.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/strstr.c$(DependSuffix): strstr.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/strstr.c$(ObjectSuffix) -MF$(IntermediateDirectory)/strstr.c$(DependSuffix) -MM "strstr.c"

$(IntermediateDirectory)/strstr.c$(PreprocessSuffix): strstr.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/strstr.c$(PreprocessSuffix) "strstr.c"

$(IntermediateDirectory)/teststrstr.c$(ObjectSuffix): teststrstr.c $(IntermediateDirectory)/teststrstr.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/strstr_tuning/teststrstr.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/teststrstr.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/teststrstr.c$(DependSuffix): teststrstr.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/teststrstr.c$(ObjectSuffix) -MF$(IntermediateDirectory)/teststrstr.c$(DependSuffix) -MM "teststrstr.c"

$(IntermediateDirectory)/teststrstr.c$(PreprocessSuffix): teststrstr.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/teststrstr.c$(PreprocessSuffix) "teststrstr.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) ./Debug/*$(ObjectSuffix)
	$(RM) ./Debug/*$(DependSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile).exe
	$(RM) "../.build-debug/strstr_tuning"


