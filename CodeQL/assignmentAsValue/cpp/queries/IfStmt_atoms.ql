/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

 predicate instancy(IfStmt e) {
    (e.getCondition() instanceof Assignment and not(e.getCondition() instanceof BlockAssignExpr)) or
    (e.getCondition() instanceof NotExpr and test_notExpr(e.getCondition())) or
    (e.getCondition() instanceof BinaryLogicalOperation and testy(e.getCondition())) or
    (e.getCondition() instanceof ComparisonOperation and testy_compOpt(e.getCondition()))
 }


 predicate test_notExpr(NotExpr e) {
   (e.getAChild() instanceof Assignment and not(e.getAChild() instanceof BlockAssignExpr)) or
   (e.getAChild() instanceof NotExpr and test_notExpr(e.getAChild())) or
   (e.getAChild() instanceof BinaryLogicalOperation and testy(e.getAChild())) or
   (e.getAChild() instanceof ComparisonOperation and testy_compOpt(e.getAChild()))
 }

 predicate testy(BinaryLogicalOperation e){
    (e.getLeftOperand() instanceof Assignment and not(e.getLeftOperand() instanceof BlockAssignExpr)) or
    (e.getRightOperand() instanceof Assignment and not(e.getRightOperand() instanceof BlockAssignExpr)) or
    (e.getLeftOperand() instanceof NotExpr and test_notExpr(e.getLeftOperand())) or
    (e.getRightOperand() instanceof NotExpr and test_notExpr(e.getRightOperand())) or
    (e.getLeftOperand() instanceof BinaryLogicalOperation and testy(e.getLeftOperand())) or
    (e.getRightOperand() instanceof BinaryLogicalOperation and testy(e.getRightOperand())) or
    (e.getLeftOperand() instanceof ComparisonOperation and testy_compOpt(e.getLeftOperand())) or
    (e.getRightOperand() instanceof ComparisonOperation and testy_compOpt(e.getRightOperand()))
 }


 predicate testy_compOpt(ComparisonOperation e) {
   (e.getLeftOperand() instanceof Assignment and not(e.getLeftOperand() instanceof BlockAssignExpr)) or
   (e.getRightOperand() instanceof Assignment and not(e.getRightOperand() instanceof BlockAssignExpr)) or
   (e.getLeftOperand() instanceof NotExpr and test_notExpr(e.getLeftOperand())) or
   (e.getRightOperand() instanceof NotExpr and test_notExpr(e.getRightOperand())) or
   (e.getLeftOperand() instanceof BinaryLogicalOperation and testy(e.getLeftOperand())) or
   (e.getRightOperand() instanceof BinaryLogicalOperation and testy(e.getRightOperand())) or
   (e.getLeftOperand() instanceof ComparisonOperation and testy_compOpt(e.getLeftOperand())) or
   (e.getRightOperand() instanceof ComparisonOperation and testy_compOpt(e.getRightOperand()))
 }


 from IfStmt e
 where instancy(e)
 select e, "This is an Assignment As Value atom"