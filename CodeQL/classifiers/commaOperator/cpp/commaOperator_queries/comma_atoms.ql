/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp


 predicate instancy(CommaExpr e) {
    checkAssign(e.getLeftOperand(), e.getRightOperand()) or
    checkCremnt(e.getLeftOperand(), e.getRightOperand())
 }


 predicate checkAssign(Expr e, Expr a) {
    e instanceof Assignment or
    a instanceof Assignment      
 }


 predicate checkCremnt(Operation e, Operation a) {
   e instanceof CrementOperation or
   a instanceof CrementOperation   
 }



 from CommaExpr e
 where instancy(e)
 select e, "This is an Comma Operator atom"