##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=extern_gcc
ConfigurationName      :=Debug
WorkspacePath          :=/Users/ac/Desktop/example
ProjectPath            :=/Users/ac/Desktop/example/extern_gcc
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
ObjectsFileList        :="extern_gcc.txt"
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
Objects0=$(IntermediateDirectory)/fc.c$(ObjectSuffix) $(IntermediateDirectory)/main.c$(ObjectSuffix) $(IntermediateDirectory)/foo.c$(ObjectSuffix) $(IntermediateDirectory)/f1.c$(ObjectSuffix) 



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
$(IntermediateDirectory)/fc.c$(ObjectSuffix): fc.c $(IntermediateDirectory)/fc.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/ac/Desktop/example/extern_gcc/fc.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/fc.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/fc.c$(DependSuffix): fc.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/fc.c$(ObjectSuffix) -MF$(IntermediateDirectory)/fc.c$(DependSuffix) -MM fc.c

$(IntermediateDirectory)/fc.c$(PreprocessSuffix): fc.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/fc.c$(PreprocessSuffix) fc.c

$(IntermediateDirectory)/main.c$(ObjectSuffix): main.c $(IntermediateDirectory)/main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/ac/Desktop/example/extern_gcc/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.c$(DependSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/main.c$(DependSuffix) -MM main.c

$(IntermediateDirectory)/main.c$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.c$(PreprocessSuffix) main.c

$(IntermediateDirectory)/foo.c$(ObjectSuffix): foo.c $(IntermediateDirectory)/foo.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/ac/Desktop/example/extern_gcc/foo.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/foo.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/foo.c$(DependSuffix): foo.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/foo.c$(ObjectSuffix) -MF$(IntermediateDirectory)/foo.c$(DependSuffix) -MM foo.c

$(IntermediateDirectory)/foo.c$(PreprocessSuffix): foo.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/foo.c$(PreprocessSuffix) foo.c

$(IntermediateDirectory)/f1.c$(ObjectSuffix): f1.c $(IntermediateDirectory)/f1.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/ac/Desktop/example/extern_gcc/f1.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/f1.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/f1.c$(DependSuffix): f1.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/f1.c$(ObjectSuffix) -MF$(IntermediateDirectory)/f1.c$(DependSuffix) -MM f1.c

$(IntermediateDirectory)/f1.c$(PreprocessSuffix): f1.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/f1.c$(PreprocessSuffix) f1.c


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


