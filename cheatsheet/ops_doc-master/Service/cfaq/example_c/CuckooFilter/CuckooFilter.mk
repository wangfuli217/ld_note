##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=CuckooFilter
ConfigurationName      :=Debug
WorkspacePath          :=/Users/mac/Desktop/example
ProjectPath            :=/Users/mac/Desktop/example/CuckooFilter
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=mac
Date                   :=12/08/2016
CodeLitePath           :="/Users/mac/Library/Application Support/codelite"
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
ObjectsFileList        :="CuckooFilter.txt"
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
CodeLiteDir:=/Users/mac/Desktop/codelite.app/Contents/SharedSupport/
Objects0=$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IntermediateDirectory)/cuckoo_filter.c$(ObjectSuffix) $(IntermediateDirectory)/sha1.c$(ObjectSuffix) 



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
$(IntermediateDirectory)/main.c$(ObjectSuffix): main.c $(IntermediateDirectory)/main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/mac/Desktop/example/CuckooFilter/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.c$(DependSuffix): main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/main.c$(DependSuffix) -MM main.c

$(IntermediateDirectory)/main.c$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.c$(PreprocessSuffix)main.c

$(IntermediateDirectory)/cuckoo_filter.c$(ObjectSuffix): cuckoo_filter.c $(IntermediateDirectory)/cuckoo_filter.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/mac/Desktop/example/CuckooFilter/cuckoo_filter.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/cuckoo_filter.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/cuckoo_filter.c$(DependSuffix): cuckoo_filter.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/cuckoo_filter.c$(ObjectSuffix) -MF$(IntermediateDirectory)/cuckoo_filter.c$(DependSuffix) -MM cuckoo_filter.c

$(IntermediateDirectory)/cuckoo_filter.c$(PreprocessSuffix): cuckoo_filter.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/cuckoo_filter.c$(PreprocessSuffix)cuckoo_filter.c

$(IntermediateDirectory)/sha1.c$(ObjectSuffix): sha1.c $(IntermediateDirectory)/sha1.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/Users/mac/Desktop/example/CuckooFilter/sha1.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/sha1.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/sha1.c$(DependSuffix): sha1.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/sha1.c$(ObjectSuffix) -MF$(IntermediateDirectory)/sha1.c$(DependSuffix) -MM sha1.c

$(IntermediateDirectory)/sha1.c$(PreprocessSuffix): sha1.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/sha1.c$(PreprocessSuffix)sha1.c


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


