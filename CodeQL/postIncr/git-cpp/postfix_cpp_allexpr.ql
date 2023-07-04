/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

from Expr e
where e instanceof PostfixIncrExpr or e instanceof PostfixDecrExpr
select e, e.getAPrimaryQlClass(), "This is a Postfix Expr"