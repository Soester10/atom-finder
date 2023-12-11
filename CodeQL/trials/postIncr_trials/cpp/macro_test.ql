/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

//  predicate instancy(BinaryArithmeticOperation e) {
//    e.getAChild() instanceof BinaryArithmeticOperation and 
//    not(e.getAChild().toString() = e.toString()) and
//    not(checkAddSub(e)) and
//    not(e.getAChild().getFullyConverted() instanceof ParenthesisExpr)

//    //  // e instanceof VariableAccess
//    //  // e instanceof FunctionCall
//    //   (e instanceof BinaryOperation and testy(e)) or
//    // //   (e instanceof ComparisonOperation and testy_comp(e)) or
//    //   (e instanceof UnaryOperation and testy_unary(e)) or
//    //   (e instanceof AssignExpr or e instanceof AssignOperation) or
//    //   e instanceof FunctionCall
//  }


predicate instancy(BinaryArithmeticOperation e) {
   not(checkSameOperand(e)) and
   not(checkAddSub(e)) and
   // not(checkPointerAddSub(e)) and
   instancyOperand(e.getLeftOperand()) or instancyOperand(e.getRightOperand())
 }



 predicate instancyOperand(BinaryArithmeticOperation e) {
   not(e.getFullyConverted() instanceof ParenthesisExpr) and
   not(e.getFullyConverted() instanceof CStyleCast and cstyleExpr(e.getFullyConverted()))
   // and e.getLeftOperand() instanceof MacroInvocation or
 }


 predicate cstyleExpr(CStyleCast e) {
   e.getExpr() instanceof ParenthesisExpr
 }


 predicate checkSameOperand(BinaryArithmeticOperation e) {
   e.getLeftOperand().toString() = e.toString() or
   e.getRightOperand().toString() = e.toString()
 }



 predicate checkAddSub(BinaryArithmeticOperation e) {
   (e instanceof SubExpr or e instanceof AddExpr or e instanceof PointerArithmeticOperation) and
   (e.getLeftOperand() instanceof SubExpr or e.getLeftOperand() instanceof AddExpr or e.getLeftOperand() instanceof PointerArithmeticOperation or
   e.getRightOperand() instanceof SubExpr or e.getRightOperand() instanceof AddExpr or e.getRightOperand() instanceof PointerArithmeticOperation)
 }



 predicate checkPointerAddSub(BinaryArithmeticOperation e) {
   (e instanceof PointerSubExpr or e instanceof PointerAddExpr or e instanceof PointerDiffExpr) //and
   // e.getLeftOperand() instanceof PointerSubExpr or e.getLeftOperand() instanceof PointerAddExpr or
   // e.getRightOperand() instanceof PointerSubExpr or e.getRightOperand() instanceof PointerAddExpr
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
 
 
//  from MacroInvocation e
// //  where instancy(e)
//  select e, "This is an Operator Precedence atom"
// select e, e.getAChild().toString()

from PointerDereferenceExpr  e
where e.getOperand() instanceof PostfixCrementOperation
select e, "Test"