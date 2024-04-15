/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

predicate instancy(IfStmt e) {
  (e.getCondition() instanceof Assignment and not(inMacroExpansion(e.getCondition())) and not (e.getCondition() instanceof BlockAssignExpr))
  or
  (e.getCondition() instanceof NotExpr and not(inMacroExpansion(e.getCondition())) and test_notExpr(e.getCondition()))
  or
  (e.getCondition() instanceof BinaryLogicalOperation and not(inMacroExpansion(e.getCondition())) and testy(e.getCondition()))
  or
  (e.getCondition() instanceof ComparisonOperation and not(inMacroExpansion(e.getCondition())) and testy_compOpt(e.getCondition()))
}

predicate test_notExpr(NotExpr e) {
  (e.getAChild() instanceof Assignment and not(inMacroExpansion(e.getAChild())) and not(e.getAChild() instanceof BlockAssignExpr))
  or
  (e.getAChild() instanceof NotExpr and not(inMacroExpansion(e.getAChild())) and test_notExpr(e.getAChild()))
  or
  (e.getAChild() instanceof BinaryLogicalOperation and not(inMacroExpansion(e.getAChild())) and testy(e.getAChild()))
  or
  (e.getAChild() instanceof ComparisonOperation and not(inMacroExpansion(e.getAChild())) and testy_compOpt(e.getAChild()))
}

predicate testy(BinaryLogicalOperation e) {
  (e.getLeftOperand() instanceof Assignment and not(inMacroExpansion(e.getLeftOperand())) and not(e.getLeftOperand() instanceof BlockAssignExpr))
  or
  (e.getRightOperand() instanceof Assignment and not(inMacroExpansion(e.getRightOperand())) and not(e.getRightOperand() instanceof BlockAssignExpr))
  or
  (e.getLeftOperand() instanceof NotExpr and not(inMacroExpansion(e.getLeftOperand())) and test_notExpr(e.getLeftOperand()))
  or
  (e.getRightOperand() instanceof NotExpr and not(inMacroExpansion(e.getRightOperand())) and test_notExpr(e.getRightOperand()))
  or
  (e.getLeftOperand() instanceof BinaryLogicalOperation and not(inMacroExpansion(e.getLeftOperand())) and testy(e.getLeftOperand()))
  or
  (e.getRightOperand() instanceof BinaryLogicalOperation and not(inMacroExpansion(e.getRightOperand())) and testy(e.getRightOperand()))
  
  // or
  // (e.getLeftOperand() instanceof ComparisonOperation and not(inMacroExpansion(e.getLeftOperand())) and ((not(e.getLeftOperand().getFullyConverted() instanceof ParenthesisExpr)) or testy_compOpt(e.getLeftOperand())))
  // or
  // (e.getRightOperand() instanceof ComparisonOperation and not(inMacroExpansion(e.getRightOperand())) and ((not(e.getRightOperand().getFullyConverted() instanceof ParenthesisExpr)) or testy_compOpt(e.getRightOperand())))

  or
  (e.getLeftOperand() instanceof ComparisonOperation and not(inMacroExpansion(e.getLeftOperand())) and testy_compOpt(e.getLeftOperand()))
  or
  (e.getRightOperand() instanceof ComparisonOperation and not(inMacroExpansion(e.getRightOperand())) and testy_compOpt(e.getRightOperand()))
  or
  (e.getLeftOperand() instanceof EqualityOperation and not inMacroExpansion(e.getLeftOperand()) and (not(e.getLeftOperand().getFullyConverted() instanceof ParenthesisExpr)))
  or
  (e.getRightOperand() instanceof EqualityOperation and not inMacroExpansion(e.getRightOperand()) and (not(e.getRightOperand().getFullyConverted() instanceof ParenthesisExpr)))
}

predicate testy_compOpt(ComparisonOperation e) {
  (e.getLeftOperand() instanceof Assignment and not(inMacroExpansion(e.getLeftOperand())) and not(e.getLeftOperand() instanceof BlockAssignExpr))
  or
  (e.getRightOperand() instanceof Assignment and not(inMacroExpansion(e.getRightOperand())) and not(e.getRightOperand() instanceof BlockAssignExpr))
  or
  (e.getLeftOperand() instanceof NotExpr and not(inMacroExpansion(e.getLeftOperand())) and test_notExpr(e.getLeftOperand()))
  or
  (e.getRightOperand() instanceof NotExpr and not(inMacroExpansion(e.getRightOperand())) and test_notExpr(e.getRightOperand()))
  or
  (e.getLeftOperand() instanceof BinaryLogicalOperation and not(inMacroExpansion(e.getLeftOperand())) and testy(e.getLeftOperand()))
  or
  (e.getRightOperand() instanceof BinaryLogicalOperation and not(inMacroExpansion(e.getRightOperand())) and testy(e.getRightOperand()))
  or
  (e.getLeftOperand() instanceof ComparisonOperation and not(inMacroExpansion(e.getLeftOperand())) and testy_compOpt(e.getLeftOperand()))
  or
  (e.getRightOperand() instanceof ComparisonOperation and not(inMacroExpansion(e.getRightOperand())) and testy_compOpt(e.getRightOperand()))
}


from IfStmt e
where instancy(e)
select e, "This is an Assignment As Value atom"
