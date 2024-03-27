/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

// string getParam(Function e) { result = e.getAParameter().toString() }
// predicate checkVariables(TopLevelFunction e) {
//   getAssignExprVar(e.getEntryPoint().getAChild()) = getParam(e)
// }
// string getAssignExprVar(ExprStmt e) { result = getLValue(e.getExpr()) }
// string getLValue(AssignExpr e) {
//   not e.getLValue() instanceof PointerFieldAccess and result = e.getLValue().toString()
// }
// from TopLevelFunction e
// where checkVariables(e)
// select e, "This is a Repurposed Variable atom"
//new
// string getParam(Function e) { result = e.getAParameter().toString() }
// predicate checkVariables(TopLevelFunction e) {
//   getAssignExprVar(e.getEntryPoint().getAChild()) = getParam(e)
// }
// string getAssignExprVar(ExprStmt e) { result = getLValue(e.getExpr()) }
// string getLValue(AssignExpr e) {
//   not e.getLValue() instanceof PointerFieldAccess and result = e.getLValue().toString()
// }
// from TopLevelFunction e
// select checkVariables(e), "This is a Repurposed Variable atom"
// predicate belongsToE(Expr e, TopLevelFunction func) {
//   exists(MethodAccess m | m.getMethod().getAncestor*() = func and m = e)
// }
// from TopLevelFunction func, AssignExpr assignExpr
// where exists(ExprStmt exprStmt | exprStmt.getParent() instanceof ExprStmt and belongsToE(exprStmt.getParent(), func))
//   and assignExpr = exprStmt.getExpr() and assignExpr instanceof AssignExpr
// select assignExpr, "This is a Repurposed Variable atom"
from Function func, ExprStmt assignExpr
where
  assignExpr.getEnclosingFunction() = func and
  assignExpr.getExpr() instanceof AssignExpr
select assignExpr, "This is a Repurposed Variable atom"
