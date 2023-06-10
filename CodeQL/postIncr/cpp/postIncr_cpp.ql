/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

// import python
 
// from Scope s
// where count(s.getAStmt()) = 0
// select s, "This is an empty scope."

import cpp

from PostfixIncrExpr p
select p, "This is a Post Increment Operation"