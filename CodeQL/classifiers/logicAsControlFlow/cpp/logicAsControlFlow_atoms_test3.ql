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
    (inMacroExpansion(e)) 
    and
     ((e instanceof BinaryOperation and testy(e)) or
   //   (e instanceof ComparisonOperation and testy_comp(e)) or
     (e instanceof UnaryOperation and testy_unary(e)) or
     (e instanceof AssignExpr or e instanceof AssignOperation) or
     e instanceof FunctionCall)
 }



 predicate conditionCheck(Expr e) {
   not(inMacroExpansion(e)) 
    and
     ((e instanceof BinaryOperation and testy(e)) or
     (e instanceof UnaryOperation and testy_unary(e)) or
     e instanceof FunctionCall)
 }
 
 predicate testy_unary(UnaryOperation e) {
    e instanceof CrementOperation or conditionCheck(e.getOperand())
 }
 
 
 predicate testy(BinaryOperation e) {
   conditionCheck(e.getLeftOperand()) or conditionCheck(e.getRightOperand())
 }


 predicate declerationCheck(Expr e) {
   not(inMacroExpansion(e)) 
    and
     ((e instanceof AssignExpr or e instanceof AssignOperation) or 
     e instanceof FunctionCall)
 }
 


 predicate parentLoopIfCheck(BinaryLogicalOperation e) {
   e.getParent() instanceof Loop or e.getParent() instanceof IfStmt
   or
   parentLoopIfCheck(e.getParent())
 }

 
 from BinaryLogicalOperation e
 where 
 not(e.getParent() instanceof Loop or e.getParent() instanceof IfStmt or parentLoopIfCheck(e.getParent())) and
 ((conditionCheck(e.getLeftOperand()) and declerationCheck(e.getRightOperand())) or
 (conditionCheck(e.getRightOperand()) and declerationCheck(e.getLeftOperand())) or
 (conditionCheck(e.getLeftOperand()) and e.getParent() instanceof ReturnStmt) or
 (conditionCheck(e.getRightOperand()) and e.getParent() instanceof ReturnStmt))
//  where (instancy(e.getLeftOperand())) or (instancy(e.getRightOperand()))
 select e, "This is a Logic as Control Flow atom"