/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

predicate checkVariableAccess(VariableAccess e) { not e instanceof FieldAccess }

predicate checkAssignExpr(Assignment e) {
  checkVariableAccess(e.getLValue()) and
  e.getLValue().toString() = checkControlFlow(e.getControlFlowScope()) and
  not prevOccurenceExists(e.getControlFlowScope(), e.getLValue().toString(), e.getLocation())
  // checkFirstVariableAccess(e.getLValue().getEnclosingVariable(), e.getControlFlowScope())
}

predicate checkCrementation(CrementOperation e) {
  e.getOperand().toString() = checkControlFlow(e.getControlFlowScope()) and
  not prevOccurenceExists(e.getControlFlowScope(), e.getOperand().toString(), e.getLocation())
  // checkFirstVariableAccess(e.getEnclosingVariable(), e.getControlFlowScope())
}

predicate prevOccurenceExists(TopLevelFunction e, string s, Location l) {
  checkforAssignment(e.getEntryPoint().getAChild(), s, l)
  or
  checkforCrementation(e.getEntryPoint().getAChild(), s, l)
}


predicate checkforCrementation(ExprStmt e, string s, Location l) {
  checkCrementExpr(e.getExpr(), s, l)
}


predicate checkCrementExpr(CrementOperation e, string s, Location l) {
  not e.getOperand() instanceof PointerFieldAccess and
  e.getOperand().toString() = s and
  e.getLocation().isBefore(l)
}

predicate checkforAssignment(ExprStmt e, string s, Location l) {
  checkAssignExpr(e.getExpr(), s, l)
}

predicate checkAssignExpr(AssignExpr e, string s, Location l) {
  not e.getLValue() instanceof PointerFieldAccess and
  e.getLValue().toString() = s and
  e.getLocation().isBefore(l)
}

string checkControlFlow(TopLevelFunction e) { result = e.getAParameter().toString() }

from Operation e
where checkAssignExpr(e) or checkCrementation(e)
select e, "This is a Repurposed Variable atom"
