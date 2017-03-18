#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include <map>
#include <vector>
#include <set>
using namespace llvm;
using namespace std;

namespace {
		map<string, set<string> > callgraph;
		struct SkeletonPass : public FunctionPass {
				static char ID;
				SkeletonPass() : FunctionPass(ID) {}

				virtual bool runOnFunction(Function &F) {
						string callerName = F.getName();
						map<string, set<string> > fpointers;
						map<string, string> defpointer;

						for (auto &B : F) {
								for (auto &I : B) {
										if (auto* call = dyn_cast<CallInst>(&I)) {
												if (auto* fun = call->getCalledFunction()){
														string calleeName = fun->getName();
														callgraph[callerName].insert(calleeName);
												}
												else{
														auto* var = call->getCalledValue();
														string label = var->getName();
														for(set<string>::iterator i = fpointers[defpointer[label]].begin(); i != fpointers[defpointer[label]].end(); ++i)
																callgraph[callerName].insert(*i);
												}

										}
										else if (auto* store = dyn_cast<StoreInst>(&I)){
												string valueName   = store->getValueOperand()->stripPointerCasts()->getName();
												string pointerName = store->getPointerOperand()->getName();
												fpointers[pointerName].insert(valueName);
												for (auto* U : store->getPointerOperand()->users()){
														if (auto* Inst = dyn_cast<Instruction>(U)) {
																if (auto* load = dyn_cast<LoadInst>(Inst)){
																		string label = load->getName();
																		defpointer[label] = pointerName;
																}
														}

												}

												
										}
								}
						}
						return false;
				}

				virtual bool doFinalization(Module &M){

						for (map<string, set<string> >::iterator i = callgraph.begin(); i != callgraph.end(); i++){
								errs() << "[" << i->first << "]: ";
								int j = 0; int n = i->second.size();
								for (set<string>::iterator ii = i->second.begin(); ii != i->second.end(); ++ii){
										errs() << "[" << *ii << "]";
										if (j != n-1) errs() << ", ";
										else errs() << "\n";
										j++;
								}

						}

						return false;
				}
		};
}

char SkeletonPass::ID = 0;
static void registerSkeletonPass(const PassManagerBuilder &, legacy::PassManagerBase &PM) {
		PM.add(new SkeletonPass());
}
static RegisterStandardPasses RegisterMyPass(PassManagerBuilder::EP_EarlyAsPossible, registerSkeletonPass);
