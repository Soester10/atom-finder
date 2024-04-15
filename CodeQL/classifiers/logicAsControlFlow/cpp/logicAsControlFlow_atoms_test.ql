/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

 predicate instancy(Expr e) {
    // e instanceof VariableAccess
    // e instanceof FunctionCall
    not(inMacroExpansion(e)) 
    and
     ((e instanceof BinaryOperation and testy(e)) or
   //   (e instanceof ComparisonOperation and testy_comp(e)) or
     (e instanceof UnaryOperation and testy_unary(e)) or
     (e instanceof AssignExpr or e instanceof AssignOperation) or
     e instanceof FunctionCall)
 }


//  predicate testy_assign(AssignExpr e) {
//    instancy(e.getLValue()) or instancy(e.getRValue())  
//  }



//  predicate testy_comp(ComparisonOperation e) {
   
//  }
 
 
 predicate testy_unary(UnaryOperation e) {
    e instanceof CrementOperation or instancy(e.getOperand())
 }
 
 
 predicate testy(BinaryOperation e) {
   instancy(e.getLeftOperand()) or instancy(e.getRightOperand())
   // e instanceof BinaryBitwiseOperation
    //  not(e instanceof ComparisonOperation) and
    //  (not(e instanceof BinaryLogicalOperation or e instanceof BinaryBitwiseOperation) or 
    //  instancy(e.getLeftOperand()) and
    //  instancy(e.getRightOperand()))
 }
 
 
 from BinaryLogicalOperation e
 where (instancy(e.getLeftOperand())) or (instancy(e.getRightOperand()))
 select e, "This is a Logic as Control Flow atom"