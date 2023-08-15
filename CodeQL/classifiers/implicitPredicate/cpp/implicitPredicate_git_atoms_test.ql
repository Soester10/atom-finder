/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

// from IfStmt e
// // where not(e instanceof ExprInVoidContext) or e.getParent() instanceof WhileStmt
// // where (e.getCondition() instanceof BinaryOperation) and not(e.getCondition() instanceof ComparisonOperation) and not(e.getCondition() instanceof SpaceshipExpr) and not(e.getCondition() instanceof BinaryLogicalOperation)
// where (e.getCondition() instanceof BinaryOperation) and not(e.getAChild() instanceof ComparisonOperation) //and e.getCondition().getAChild() instance of ComparisonOperation 
// select e, "This is an Implicit Predicate atom"


predicate condy(Stmt e){
    e instanceof Loop or 
    e instanceof IfStmt
}

predicate instancy(Expr e) {
    (not(e instanceof BinaryOperation) or testy(e)) and
    (not(e instanceof UnaryOperation) or testy_unary(e))
    // e instanceof UnaryOperation or
    // e instanceof Call
}


predicate testy_unary(UnaryOperation e) {
    instancy(e.getOperand())
}


predicate testy(BinaryOperation e) {
    // (e.getParent() instanceof IfStmt) and not(e.getAChild() instanceof ComparisonOperation)
    not(e instanceof ComparisonOperation) and
    // (not(e instanceof BinaryLogicalOperation or e instanceof BinaryBitwiseOperation) or 
    // (not(e.getLeftOperand() instanceof BinaryOperation) or testy(e.getLeftOperand())) and 
    // (not(e.getRightOperand() instanceof BinaryOperation) or testy(e.getRightOperand()))

    // (not(e.getLeftOperand() instanceof BinaryOperation) or testy(e.getLeftOperand())) and 
    // (not(e.getRightOperand() instanceof BinaryOperation) or testy(e.getRightOperand()))

    instancy(e.getLeftOperand()) and
    instancy(e.getRightOperand())
    
    // (not(e instanceof BinaryLogicalOperation or e instanceof BinaryBitwiseOperation) or testy(e.getLeftOperand()))
}


from Loop e
// where e.getParent() instance of IfStmt and testy(e)
// where testy(e) //and e.getCondition().getAChild() instanceof ComparisonOperation 
// where (e.getCondition() instanceof BinaryOperation) and not(e.getCondition().getAChild() instanceof ComparisonOperation)
// where (e.getCondition() instanceof BinaryOperation) and testy(e.getCondition())

where (instancy(e.getCondition())) //and testy(e.getCondition())

select e, "This is an Implicit Predicate atom"