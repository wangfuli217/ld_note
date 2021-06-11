##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=libconhash
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\libconhash"
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
OutputFile             :=$(IntermediateDirectory)/$(ProjectName).so
Preprocessors          :=
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E 
ObjectsFileList        :="E:\data\example\libconhash\libconhash.txt"
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
CXXFLAGS :=  -g $(Preprocessors)
CFLAGS   :=  -g $(Preprocessors)


##
## User defined environment variables
##
CodeLiteDir:=d:\Program Files\CodeLite
UNIT_TEST_PP_SRC_DIR:=d:\UnitTest++-1.3
Objects=$(IntermediateDirectory)/conhash$(ObjectSuffix) $(IntermediateDirectory)/conhash_inter$(ObjectSuffix) $(IntermediateDirectory)/conhash_util$(ObjectSuffix) $(IntermediateDirectory)/md5$(ObjectSuffix) $(IntermediateDirectory)/sample$(ObjectSuffix) $(IntermediateDirectory)/util_rbtree$(ObjectSuffix) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects) > $(ObjectsFileList)
	$(SharedObjectLinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)
	@$(MakeDirCommand) "E:\data\example\.build-debug"
	@echo rebuilt > "E:\data\example\.build-debug\libconhash"

$(IntermediateDirectory)/.d:
	@$(MakeDirCommand) "./Debug"

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/conhash$(ObjectSuffix): conhash.c $(IntermediateDirectory)/conhash$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/libconhash/conhash.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/conhash$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/conhash$(DependSuffix): conhash.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/conhash$(ObjectSuffix) -MF$(IntermediateDirectory)/conhash$(DependSuffix) -MM "E:/data/example/libconhash/conhash.c"

$(IntermediateDirectory)/conhash$(PreprocessSuffix): conhash.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/conhash$(PreprocessSuffix) "E:/data/example/libconhash/conhash.c"

$(IntermediateDirectory)/conhash_inter$(ObjectSuffix): conhash_inter.c $(IntermediateDirectory)/conhash_inter$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/libconhash/conhash_inter.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/conhash_inter$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/conhash_inter$(DependSuffix): conhash_inter.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/conhash_inter$(ObjectSuffix) -MF$(IntermediateDirectory)/conhash_inter$(DependSuffix) -MM "E:/data/example/libconhash/conhash_inter.c"

$(IntermediateDirectory)/conhash_inter$(PreprocessSuffix): conhash_inter.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/conhash_inter$(PreprocessSuffix) "E:/data/example/libconhash/conhash_inter.c"

$(IntermediateDirectory)/conhash_util$(ObjectSuffix): conhash_util.c $(IntermediateDirectory)/conhash_util$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/libconhash/conhash_util.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/conhash_util$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/conhash_util$(DependSuffix): conhash_util.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/conhash_util$(ObjectSuffix) -MF$(IntermediateDirectory)/conhash_util$(DependSuffix) -MM "E:/data/example/libconhash/conhash_util.c"

$(IntermediateDirectory)/conhash_util$(PreprocessSuffix): conhash_util.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/conhash_util$(PreprocessSuffix) "E:/data/example/libconhash/conhash_util.c"

$(IntermediateDirectory)/md5$(ObjectSuffix): md5.c $(IntermediateDirectory)/md5$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/libconhash/md5.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/md5$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/md5$(DependSuffix): md5.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/md5$(ObjectSuffix) -MF$(IntermediateDirectory)/md5$(DependSuffix) -MM "E:/data/example/libconhash/md5.c"

$(IntermediateDirectory)/md5$(PreprocessSuffix): md5.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/md5$(PreprocessSuffix) "E:/data/example/libconhash/md5.c"

$(IntermediateDirectory)/sample$(ObjectSuffix): sample.c $(IntermediateDirectory)/sample$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/libconhash/sample.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/sample$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/sample$(DependSuffix): sample.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/sample$(ObjectSuffix) -MF$(IntermediateDirectory)/sample$(DependSuffix) -MM "E:/data/example/libconhash/sample.c"

$(IntermediateDirectory)/sample$(PreprocessSuffix): sample.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/sample$(PreprocessSuffix) "E:/data/example/libconhash/sample.c"

$(IntermediateDirectory)/util_rbtree$(ObjectSuffix): util_rbtree.c $(IntermediateDirectory)/util_rbtree$(DependSuffix)
	$(CC) $(SourceSwitch) "E:/data/example/libconhash/util_rbtree.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/util_rbtree$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/util_rbtree$(DependSuffix): util_rbtree.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/util_rbtree$(ObjectSuffix) -MF$(IntermediateDirectory)/util_rbtree$(DependSuffix) -MM "E:/data/example/libconhash/util_rbtree.c"

$(IntermediateDirectory)/util_rbtree$(PreprocessSuffix): util_rbtree.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/util_rbtree$(PreprocessSuffix) "E:/data/example/libconhash/util_rbtree.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) $(IntermediateDirectory)/conhash$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/conhash$(DependSuffix)
	$(RM) $(IntermediateDirectory)/conhash$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/conhash_inter$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/conhash_inter$(DependSuffix)
	$(RM) $(IntermediateDirectory)/conhash_inter$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/conhash_util$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/conhash_util$(DependSuffix)
	$(RM) $(IntermediateDirectory)/conhash_util$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/md5$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/md5$(DependSuffix)
	$(RM) $(IntermediateDirectory)/md5$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/sample$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/sample$(DependSuffix)
	$(RM) $(IntermediateDirectory)/sample$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/util_rbtree$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/util_rbtree$(DependSuffix)
	$(RM) $(IntermediateDirectory)/util_rbtree$(PreprocessSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile)
	$(RM) "E:\data\example\.build-debug\libconhash"


