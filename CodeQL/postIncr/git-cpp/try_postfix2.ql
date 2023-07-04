/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

//  from ExprStmt e
//  where e.getAChild() instanceof PostfixIncrExpr or 
//  e.getAChild() instanceof PostfixDecrExpr
//  select e, "This is a Postfix atom"


// from Call e
// where e.getAChild() instanceof PostfixIncrExpr
// // e.getExpr() instanceof PostfixDecrExpr
// select e, "This is a Postfix atom"


import cpp

from PostfixCrementOperation e
where e.getParent() instanceof Expr
// where not(e instanceof ExprInVoidContext) or e.getParent() instanceof Expr
select e, "This is a Postfix atom"