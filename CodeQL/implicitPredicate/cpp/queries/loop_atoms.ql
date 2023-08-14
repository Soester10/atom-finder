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
     (not(e instanceof BinaryOperation) or testy(e)) and
     (not(e instanceof UnaryOperation) or testy_unary(e))
 }
 
 
 predicate testy_unary(UnaryOperation e) {
    not(e instanceof NotExpr) and instancy(e.getOperand())
 }
 
 
 predicate testy(BinaryOperation e) {
   e instanceof BinaryBitwiseOperation
    //  not(e instanceof ComparisonOperation) and
    //  (not(e instanceof BinaryLogicalOperation or e instanceof BinaryBitwiseOperation) or 
    //  instancy(e.getLeftOperand()) and
    //  instancy(e.getRightOperand()))
 }
 
 
 from Loop e
 where (instancy(e.getCondition()))
 select e, "This is an Implicit Predicate atom"