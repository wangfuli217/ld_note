##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=RBTree_2
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\RBTree_2"
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
ObjectsFileList        :="RBTree_2.txt"
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
Objects0=$(IntermediateDirectory)/rbtest1.c$(ObjectSuffix) $(IntermediateDirectory)/rbtree.c$(ObjectSuffix) $(IntermediateDirectory)/rbtree_rc.c$(ObjectSuffix) 



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
$(IntermediateDirectory)/rbtest1.c$(ObjectSuffix): rbtest1.c $(IntermediateDirectory)/rbtest1.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/RBTree_2/rbtest1.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/rbtest1.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/rbtest1.c$(DependSuffix): rbtest1.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/rbtest1.c$(ObjectSuffix) -MF$(IntermediateDirectory)/rbtest1.c$(DependSuffix) -MM "rbtest1.c"

$(IntermediateDirectory)/rbtest1.c$(PreprocessSuffix): rbtest1.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/rbtest1.c$(PreprocessSuffix) "rbtest1.c"

$(IntermediateDirectory)/rbtree.c$(ObjectSuffix): rbtree.c $(IntermediateDirectory)/rbtree.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/RBTree_2/rbtree.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/rbtree.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/rbtree.c$(DependSuffix): rbtree.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/rbtree.c$(ObjectSuffix) -MF$(IntermediateDirectory)/rbtree.c$(DependSuffix) -MM "rbtree.c"

$(IntermediateDirectory)/rbtree.c$(PreprocessSuffix): rbtree.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/rbtree.c$(PreprocessSuffix) "rbtree.c"

$(IntermediateDirectory)/rbtree_rc.c$(ObjectSuffix): rbtree_rc.c $(IntermediateDirectory)/rbtree_rc.c$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/RBTree_2/rbtree_rc.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/rbtree_rc.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/rbtree_rc.c$(DependSuffix): rbtree_rc.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/rbtree_rc.c$(ObjectSuffix) -MF$(IntermediateDirectory)/rbtree_rc.c$(DependSuffix) -MM "rbtree_rc.c"

$(IntermediateDirectory)/rbtree_rc.c$(PreprocessSuffix): rbtree_rc.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/rbtree_rc.c$(PreprocessSuffix) "rbtree_rc.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


