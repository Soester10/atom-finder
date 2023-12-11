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
   result = instancy2(e.getAParameter(), checkBlockStmt(e.getEntryPoint()))
 }


 string instancy2(Parameter e, string s){
   e.toString() = s and result = e.toString()
 }




 string checkBlockStmt(BlockStmt e) {
   result = checkExprStmt(e.getAStmt())
 }



 string checkExprStmt(ExprStmt e) {
   result = checkAssignExpr(e.getExpr())
 }



 string checkAssignExpr(AssignExpr e) {
   // e.getLValue() instanceof VariableAccess and result = e.getLValue().toString()
   result = checkVariableAccess(e.getLValue())
 }


 string checkVariableAccess(VariableAccess e){
   not(e instanceof FieldAccess) and
   result = e.toString()
 }



 from TopLevelFunction e
//  where instancy(e)
 select e, "This is a Repurposed Variable atom"