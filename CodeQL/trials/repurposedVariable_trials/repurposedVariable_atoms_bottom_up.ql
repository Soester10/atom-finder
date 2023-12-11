/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp





//  predicate instancy(TopLevelFunction e) {
//    // e.getAParameter().toString() == statmenty(e.get)
//    e.getAParameter().toString() = checkBlockStmt(e.getEntryPoint())
//  }


 string instancy(TopLevelFunction e) {
   // e.getAParameter().toString() == statmenty(e.get)
   // e.getAParameter().toString() = checkBlockStmt(e.getEntryPoint()) and result = e.getAParameter().toString()
  //  result = instancy2(e.getAParameter(), checkBlockStmt(e.getEntryPoint()))
  result = e.getAParameter().toString()
 }


//  string instancy2(Parameter e, string s){
//    e.toString() = s and result = e.toString()
//  }


string instancy2(StmtParent e){
  // e.toString() = s and result = e.toString()
  result = instancy(e.getControlFlowScope())
}




 string checkBlockStmt(BlockStmt e) {
  //  result = checkExprStmt(e.getAStmt())
  // result = instancy2(e.getParent())
  result = instancy(e.getControlFlowScope())
 }



 string checkExprStmt(ExprStmt e) {
  //  result = checkAssignExpr(e.getExpr())
  result = checkBlockStmt(e.getParent())
 }



//  string checkAssignExpr(AssignExpr e) {
//    // e.getLValue() instanceof VariableAccess and result = e.getLValue().toString()
//    result = checkVariableAccess(e.getLValue())
//  }


 predicate checkVariableAccess(VariableAccess e){
   not(e instanceof FieldAccess)
 }








 predicate checkAssignExpr(Assignment e) {
  // e.getLValue() instanceof VariableAccess and result = e.getLValue().toString()
  // checkVariableAccess(e.getLValue()) and e.getLValue().toString() = checkExprStmt(e.getParent())
  checkVariableAccess(e.getLValue()) and e.getLValue().toString() = checkControlFlow(e.getControlFlowScope())
}



predicate checkCremation(CrementOperation e) {
  e.getOperand().toString() = checkControlFlow(e.getControlFlowScope())
}





string checkControlFlow(TopLevelFunction e) {
  result = e.getAParameter().toString() 
}



 from Operation e
 where checkAssignExpr(e) or checkCremation(e)
 select e, "This is a Repurposed Variable atom"