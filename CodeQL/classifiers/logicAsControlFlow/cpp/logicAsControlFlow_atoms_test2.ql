/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

 predicate instancy(BinaryLogicalOperation e) {
    // e instanceof VariableAccess
    // e instanceof FunctionCall
    not(inMacroExpansion(e)) 
    and

     (((e.getLeftOperand() instanceof FunctionCall) or 
     (e.getRightOperand() instanceof FunctionCall))

     or 

     ((testy(e.getLeftOperand()) or testy(e.getRightOperand())) or
   //   (e instanceof ComparisonOperation and testy_comp(e)) or
     (testy_unary(e.getLeftOperand()) or testy_unary(e.getRightOperand()))))
   //   or
   //   (e instanceof AssignExpr or e instanceof AssignOperation)))
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
 where (instancy(e))
 select e, "This is a Logic as Control Flow atom"