#include "node.h"

llvm::Value* Node::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NInteger::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NDouble::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NIdentifier::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NMethodCall::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NBinaryOperator::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NAssignment::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NBlock::codeGen(CodeGenContext& context) {
	StatementList::const_iterator it;
	llvm::Value *last = NULL;
	for (it=statements.begin(); it!=statements.end(); it++) {
		std::cout << "Generating code for " << typeid(*it).name() << std::endl;
		last = (**it).codeGen(context);
	}
	return last;
}

llvm::Value* NExpressionStatement::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NVariableDeclaration::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}

llvm::Value* NFunctionDeclaration::codeGen(CodeGenContext& context) {
	llvm::Value *last = NULL;
	return last;
}
