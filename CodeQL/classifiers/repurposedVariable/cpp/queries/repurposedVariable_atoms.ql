/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp


 
 predicate checkVariableAccess(VariableAccess e){
   not(e instanceof FieldAccess)
 }



 predicate checkAssignExpr(Assignment e) {
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