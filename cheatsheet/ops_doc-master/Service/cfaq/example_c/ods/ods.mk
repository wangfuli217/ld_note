##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=ods
ConfigurationName      :=Debug
WorkspacePath          := "E:\data\example"
ProjectPath            := "E:\data\example\ods"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=AustinChen
Date                   :=02/04/15
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
ObjectsFileList        :="ods.txt"
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
Objects0=$(IntermediateDirectory)/main.cpp$(ObjectSuffix) $(IntermediateDirectory)/AdjacencyLists.cpp$(ObjectSuffix) $(IntermediateDirectory)/AdjacencyMatrix.cpp$(ObjectSuffix) $(IntermediateDirectory)/array.cpp$(ObjectSuffix) $(IntermediateDirectory)/ArrayDeque.cpp$(ObjectSuffix) $(IntermediateDirectory)/ArrayQueue.cpp$(ObjectSuffix) $(IntermediateDirectory)/ArrayStack.cpp$(ObjectSuffix) $(IntermediateDirectory)/BinaryHeap.cpp$(ObjectSuffix) $(IntermediateDirectory)/BinarySearchTree.cpp$(ObjectSuffix) $(IntermediateDirectory)/BinaryTree.cpp$(ObjectSuffix) \
	$(IntermediateDirectory)/BinaryTrie.cpp$(ObjectSuffix) $(IntermediateDirectory)/ChainedHashTable.cpp$(ObjectSuffix) $(IntermediateDirectory)/DLList.cpp$(ObjectSuffix) $(IntermediateDirectory)/DualArrayDeque.cpp$(ObjectSuffix) $(IntermediateDirectory)/FastArrayStack.cpp$(ObjectSuffix) $(IntermediateDirectory)/FastSqrt.cpp$(ObjectSuffix) $(IntermediateDirectory)/LinearHashTable.cpp$(ObjectSuffix) $(IntermediateDirectory)/MeldableHeap.cpp$(ObjectSuffix) $(IntermediateDirectory)/RedBlackTree.cpp$(ObjectSuffix) $(IntermediateDirectory)/RootishArrayStack.cpp$(ObjectSuffix) \
	$(IntermediateDirectory)/ScapegoatTree.cpp$(ObjectSuffix) $(IntermediateDirectory)/SEList.cpp$(ObjectSuffix) $(IntermediateDirectory)/SkiplistSSet.cpp$(ObjectSuffix) $(IntermediateDirectory)/SLList.cpp$(ObjectSuffix) $(IntermediateDirectory)/Treap.cpp$(ObjectSuffix) $(IntermediateDirectory)/utils.cpp$(ObjectSuffix) $(IntermediateDirectory)/XFastTrie.cpp$(ObjectSuffix) $(IntermediateDirectory)/YFastTrie.cpp$(ObjectSuffix) 



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
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/main.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main.cpp$(DependSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/main.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/main.cpp$(DependSuffix) -MM "main.cpp"

$(IntermediateDirectory)/main.cpp$(PreprocessSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main.cpp$(PreprocessSuffix) "main.cpp"

$(IntermediateDirectory)/AdjacencyLists.cpp$(ObjectSuffix): AdjacencyLists.cpp $(IntermediateDirectory)/AdjacencyLists.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/AdjacencyLists.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/AdjacencyLists.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/AdjacencyLists.cpp$(DependSuffix): AdjacencyLists.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/AdjacencyLists.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/AdjacencyLists.cpp$(DependSuffix) -MM "AdjacencyLists.cpp"

$(IntermediateDirectory)/AdjacencyLists.cpp$(PreprocessSuffix): AdjacencyLists.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/AdjacencyLists.cpp$(PreprocessSuffix) "AdjacencyLists.cpp"

$(IntermediateDirectory)/AdjacencyMatrix.cpp$(ObjectSuffix): AdjacencyMatrix.cpp $(IntermediateDirectory)/AdjacencyMatrix.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/AdjacencyMatrix.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/AdjacencyMatrix.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/AdjacencyMatrix.cpp$(DependSuffix): AdjacencyMatrix.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/AdjacencyMatrix.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/AdjacencyMatrix.cpp$(DependSuffix) -MM "AdjacencyMatrix.cpp"

$(IntermediateDirectory)/AdjacencyMatrix.cpp$(PreprocessSuffix): AdjacencyMatrix.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/AdjacencyMatrix.cpp$(PreprocessSuffix) "AdjacencyMatrix.cpp"

$(IntermediateDirectory)/array.cpp$(ObjectSuffix): array.cpp $(IntermediateDirectory)/array.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/array.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/array.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/array.cpp$(DependSuffix): array.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/array.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/array.cpp$(DependSuffix) -MM "array.cpp"

$(IntermediateDirectory)/array.cpp$(PreprocessSuffix): array.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/array.cpp$(PreprocessSuffix) "array.cpp"

$(IntermediateDirectory)/ArrayDeque.cpp$(ObjectSuffix): ArrayDeque.cpp $(IntermediateDirectory)/ArrayDeque.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/ArrayDeque.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/ArrayDeque.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/ArrayDeque.cpp$(DependSuffix): ArrayDeque.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/ArrayDeque.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/ArrayDeque.cpp$(DependSuffix) -MM "ArrayDeque.cpp"

$(IntermediateDirectory)/ArrayDeque.cpp$(PreprocessSuffix): ArrayDeque.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/ArrayDeque.cpp$(PreprocessSuffix) "ArrayDeque.cpp"

$(IntermediateDirectory)/ArrayQueue.cpp$(ObjectSuffix): ArrayQueue.cpp $(IntermediateDirectory)/ArrayQueue.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/ArrayQueue.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/ArrayQueue.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/ArrayQueue.cpp$(DependSuffix): ArrayQueue.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/ArrayQueue.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/ArrayQueue.cpp$(DependSuffix) -MM "ArrayQueue.cpp"

$(IntermediateDirectory)/ArrayQueue.cpp$(PreprocessSuffix): ArrayQueue.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/ArrayQueue.cpp$(PreprocessSuffix) "ArrayQueue.cpp"

$(IntermediateDirectory)/ArrayStack.cpp$(ObjectSuffix): ArrayStack.cpp $(IntermediateDirectory)/ArrayStack.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/ArrayStack.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/ArrayStack.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/ArrayStack.cpp$(DependSuffix): ArrayStack.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/ArrayStack.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/ArrayStack.cpp$(DependSuffix) -MM "ArrayStack.cpp"

$(IntermediateDirectory)/ArrayStack.cpp$(PreprocessSuffix): ArrayStack.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/ArrayStack.cpp$(PreprocessSuffix) "ArrayStack.cpp"

$(IntermediateDirectory)/BinaryHeap.cpp$(ObjectSuffix): BinaryHeap.cpp $(IntermediateDirectory)/BinaryHeap.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/BinaryHeap.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/BinaryHeap.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/BinaryHeap.cpp$(DependSuffix): BinaryHeap.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/BinaryHeap.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/BinaryHeap.cpp$(DependSuffix) -MM "BinaryHeap.cpp"

$(IntermediateDirectory)/BinaryHeap.cpp$(PreprocessSuffix): BinaryHeap.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/BinaryHeap.cpp$(PreprocessSuffix) "BinaryHeap.cpp"

$(IntermediateDirectory)/BinarySearchTree.cpp$(ObjectSuffix): BinarySearchTree.cpp $(IntermediateDirectory)/BinarySearchTree.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/BinarySearchTree.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/BinarySearchTree.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/BinarySearchTree.cpp$(DependSuffix): BinarySearchTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/BinarySearchTree.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/BinarySearchTree.cpp$(DependSuffix) -MM "BinarySearchTree.cpp"

$(IntermediateDirectory)/BinarySearchTree.cpp$(PreprocessSuffix): BinarySearchTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/BinarySearchTree.cpp$(PreprocessSuffix) "BinarySearchTree.cpp"

$(IntermediateDirectory)/BinaryTree.cpp$(ObjectSuffix): BinaryTree.cpp $(IntermediateDirectory)/BinaryTree.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/BinaryTree.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/BinaryTree.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/BinaryTree.cpp$(DependSuffix): BinaryTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/BinaryTree.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/BinaryTree.cpp$(DependSuffix) -MM "BinaryTree.cpp"

$(IntermediateDirectory)/BinaryTree.cpp$(PreprocessSuffix): BinaryTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/BinaryTree.cpp$(PreprocessSuffix) "BinaryTree.cpp"

$(IntermediateDirectory)/BinaryTrie.cpp$(ObjectSuffix): BinaryTrie.cpp $(IntermediateDirectory)/BinaryTrie.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/BinaryTrie.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/BinaryTrie.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/BinaryTrie.cpp$(DependSuffix): BinaryTrie.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/BinaryTrie.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/BinaryTrie.cpp$(DependSuffix) -MM "BinaryTrie.cpp"

$(IntermediateDirectory)/BinaryTrie.cpp$(PreprocessSuffix): BinaryTrie.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/BinaryTrie.cpp$(PreprocessSuffix) "BinaryTrie.cpp"

$(IntermediateDirectory)/ChainedHashTable.cpp$(ObjectSuffix): ChainedHashTable.cpp $(IntermediateDirectory)/ChainedHashTable.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/ChainedHashTable.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/ChainedHashTable.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/ChainedHashTable.cpp$(DependSuffix): ChainedHashTable.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/ChainedHashTable.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/ChainedHashTable.cpp$(DependSuffix) -MM "ChainedHashTable.cpp"

$(IntermediateDirectory)/ChainedHashTable.cpp$(PreprocessSuffix): ChainedHashTable.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/ChainedHashTable.cpp$(PreprocessSuffix) "ChainedHashTable.cpp"

$(IntermediateDirectory)/DLList.cpp$(ObjectSuffix): DLList.cpp $(IntermediateDirectory)/DLList.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/DLList.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/DLList.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/DLList.cpp$(DependSuffix): DLList.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/DLList.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/DLList.cpp$(DependSuffix) -MM "DLList.cpp"

$(IntermediateDirectory)/DLList.cpp$(PreprocessSuffix): DLList.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/DLList.cpp$(PreprocessSuffix) "DLList.cpp"

$(IntermediateDirectory)/DualArrayDeque.cpp$(ObjectSuffix): DualArrayDeque.cpp $(IntermediateDirectory)/DualArrayDeque.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/DualArrayDeque.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/DualArrayDeque.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/DualArrayDeque.cpp$(DependSuffix): DualArrayDeque.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/DualArrayDeque.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/DualArrayDeque.cpp$(DependSuffix) -MM "DualArrayDeque.cpp"

$(IntermediateDirectory)/DualArrayDeque.cpp$(PreprocessSuffix): DualArrayDeque.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/DualArrayDeque.cpp$(PreprocessSuffix) "DualArrayDeque.cpp"

$(IntermediateDirectory)/FastArrayStack.cpp$(ObjectSuffix): FastArrayStack.cpp $(IntermediateDirectory)/FastArrayStack.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/FastArrayStack.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/FastArrayStack.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/FastArrayStack.cpp$(DependSuffix): FastArrayStack.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/FastArrayStack.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/FastArrayStack.cpp$(DependSuffix) -MM "FastArrayStack.cpp"

$(IntermediateDirectory)/FastArrayStack.cpp$(PreprocessSuffix): FastArrayStack.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/FastArrayStack.cpp$(PreprocessSuffix) "FastArrayStack.cpp"

$(IntermediateDirectory)/FastSqrt.cpp$(ObjectSuffix): FastSqrt.cpp $(IntermediateDirectory)/FastSqrt.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/FastSqrt.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/FastSqrt.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/FastSqrt.cpp$(DependSuffix): FastSqrt.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/FastSqrt.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/FastSqrt.cpp$(DependSuffix) -MM "FastSqrt.cpp"

$(IntermediateDirectory)/FastSqrt.cpp$(PreprocessSuffix): FastSqrt.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/FastSqrt.cpp$(PreprocessSuffix) "FastSqrt.cpp"

$(IntermediateDirectory)/LinearHashTable.cpp$(ObjectSuffix): LinearHashTable.cpp $(IntermediateDirectory)/LinearHashTable.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/LinearHashTable.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/LinearHashTable.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/LinearHashTable.cpp$(DependSuffix): LinearHashTable.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/LinearHashTable.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/LinearHashTable.cpp$(DependSuffix) -MM "LinearHashTable.cpp"

$(IntermediateDirectory)/LinearHashTable.cpp$(PreprocessSuffix): LinearHashTable.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/LinearHashTable.cpp$(PreprocessSuffix) "LinearHashTable.cpp"

$(IntermediateDirectory)/MeldableHeap.cpp$(ObjectSuffix): MeldableHeap.cpp $(IntermediateDirectory)/MeldableHeap.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/MeldableHeap.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/MeldableHeap.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/MeldableHeap.cpp$(DependSuffix): MeldableHeap.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/MeldableHeap.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/MeldableHeap.cpp$(DependSuffix) -MM "MeldableHeap.cpp"

$(IntermediateDirectory)/MeldableHeap.cpp$(PreprocessSuffix): MeldableHeap.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/MeldableHeap.cpp$(PreprocessSuffix) "MeldableHeap.cpp"

$(IntermediateDirectory)/RedBlackTree.cpp$(ObjectSuffix): RedBlackTree.cpp $(IntermediateDirectory)/RedBlackTree.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/RedBlackTree.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/RedBlackTree.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/RedBlackTree.cpp$(DependSuffix): RedBlackTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/RedBlackTree.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/RedBlackTree.cpp$(DependSuffix) -MM "RedBlackTree.cpp"

$(IntermediateDirectory)/RedBlackTree.cpp$(PreprocessSuffix): RedBlackTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/RedBlackTree.cpp$(PreprocessSuffix) "RedBlackTree.cpp"

$(IntermediateDirectory)/RootishArrayStack.cpp$(ObjectSuffix): RootishArrayStack.cpp $(IntermediateDirectory)/RootishArrayStack.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/RootishArrayStack.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/RootishArrayStack.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/RootishArrayStack.cpp$(DependSuffix): RootishArrayStack.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/RootishArrayStack.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/RootishArrayStack.cpp$(DependSuffix) -MM "RootishArrayStack.cpp"

$(IntermediateDirectory)/RootishArrayStack.cpp$(PreprocessSuffix): RootishArrayStack.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/RootishArrayStack.cpp$(PreprocessSuffix) "RootishArrayStack.cpp"

$(IntermediateDirectory)/ScapegoatTree.cpp$(ObjectSuffix): ScapegoatTree.cpp $(IntermediateDirectory)/ScapegoatTree.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/ScapegoatTree.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/ScapegoatTree.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/ScapegoatTree.cpp$(DependSuffix): ScapegoatTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/ScapegoatTree.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/ScapegoatTree.cpp$(DependSuffix) -MM "ScapegoatTree.cpp"

$(IntermediateDirectory)/ScapegoatTree.cpp$(PreprocessSuffix): ScapegoatTree.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/ScapegoatTree.cpp$(PreprocessSuffix) "ScapegoatTree.cpp"

$(IntermediateDirectory)/SEList.cpp$(ObjectSuffix): SEList.cpp $(IntermediateDirectory)/SEList.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/SEList.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/SEList.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/SEList.cpp$(DependSuffix): SEList.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/SEList.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/SEList.cpp$(DependSuffix) -MM "SEList.cpp"

$(IntermediateDirectory)/SEList.cpp$(PreprocessSuffix): SEList.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/SEList.cpp$(PreprocessSuffix) "SEList.cpp"

$(IntermediateDirectory)/SkiplistSSet.cpp$(ObjectSuffix): SkiplistSSet.cpp $(IntermediateDirectory)/SkiplistSSet.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/SkiplistSSet.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/SkiplistSSet.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/SkiplistSSet.cpp$(DependSuffix): SkiplistSSet.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/SkiplistSSet.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/SkiplistSSet.cpp$(DependSuffix) -MM "SkiplistSSet.cpp"

$(IntermediateDirectory)/SkiplistSSet.cpp$(PreprocessSuffix): SkiplistSSet.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/SkiplistSSet.cpp$(PreprocessSuffix) "SkiplistSSet.cpp"

$(IntermediateDirectory)/SLList.cpp$(ObjectSuffix): SLList.cpp $(IntermediateDirectory)/SLList.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/SLList.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/SLList.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/SLList.cpp$(DependSuffix): SLList.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/SLList.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/SLList.cpp$(DependSuffix) -MM "SLList.cpp"

$(IntermediateDirectory)/SLList.cpp$(PreprocessSuffix): SLList.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/SLList.cpp$(PreprocessSuffix) "SLList.cpp"

$(IntermediateDirectory)/Treap.cpp$(ObjectSuffix): Treap.cpp $(IntermediateDirectory)/Treap.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/Treap.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/Treap.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/Treap.cpp$(DependSuffix): Treap.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/Treap.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/Treap.cpp$(DependSuffix) -MM "Treap.cpp"

$(IntermediateDirectory)/Treap.cpp$(PreprocessSuffix): Treap.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/Treap.cpp$(PreprocessSuffix) "Treap.cpp"

$(IntermediateDirectory)/utils.cpp$(ObjectSuffix): utils.cpp $(IntermediateDirectory)/utils.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/utils.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/utils.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/utils.cpp$(DependSuffix): utils.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/utils.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/utils.cpp$(DependSuffix) -MM "utils.cpp"

$(IntermediateDirectory)/utils.cpp$(PreprocessSuffix): utils.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/utils.cpp$(PreprocessSuffix) "utils.cpp"

$(IntermediateDirectory)/XFastTrie.cpp$(ObjectSuffix): XFastTrie.cpp $(IntermediateDirectory)/XFastTrie.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/XFastTrie.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/XFastTrie.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/XFastTrie.cpp$(DependSuffix): XFastTrie.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/XFastTrie.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/XFastTrie.cpp$(DependSuffix) -MM "XFastTrie.cpp"

$(IntermediateDirectory)/XFastTrie.cpp$(PreprocessSuffix): XFastTrie.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/XFastTrie.cpp$(PreprocessSuffix) "XFastTrie.cpp"

$(IntermediateDirectory)/YFastTrie.cpp$(ObjectSuffix): YFastTrie.cpp $(IntermediateDirectory)/YFastTrie.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "E:/data/example/ods/YFastTrie.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/YFastTrie.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/YFastTrie.cpp$(DependSuffix): YFastTrie.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/YFastTrie.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/YFastTrie.cpp$(DependSuffix) -MM "YFastTrie.cpp"

$(IntermediateDirectory)/YFastTrie.cpp$(PreprocessSuffix): YFastTrie.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/YFastTrie.cpp$(PreprocessSuffix) "YFastTrie.cpp"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) ./Debug/*$(ObjectSuffix)
	$(RM) ./Debug/*$(DependSuffix)
	$(RM) $(OutputFile)
	$(RM) $(OutputFile).exe
	$(RM) "../.build-debug/ods"


