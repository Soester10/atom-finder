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

import javascript

from PostIncExpr p
select p, "This is a Post Increment Operation"