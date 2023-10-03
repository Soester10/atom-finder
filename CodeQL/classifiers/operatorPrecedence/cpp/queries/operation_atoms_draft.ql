/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

//  TODO:Do non-asso
 import cpp

//  predicate instancy(BinaryArithmeticOperation e) {
//    e.getAChild() instanceof BinaryArithmeticOperation and 
//    not(e.getAChild().toString() = e.toString()) and
//    not(checkAddSub(e)) and
//    not(e.getAChild().getFullyConverted() instanceof ParenthesisExpr)

//    //  // e instanceof VariableAccess
//    //  // e instanceof FunctionCall
//    //   (e instanceof BinaryOperation and testy(e)) or
//    // //   (e instanceof ComparisonOperation and testy_comp(e)) or
//    //   (e instanceof UnaryOperation and testy_unary(e)) or
//    //   (e instanceof AssignExpr or e instanceof AssignOperation) or
//    //   e instanceof FunctionCall
//  }


predicate instancy(Operation e) {
  // not(checkSameOperand(e)) and
  (checkInSensitiveCombinations(e) or checkSensitiveCombinations(e)) and
  // e instanceof AddressOfExpr and
   
  //  not(checkAddSub(e)) and
   // not(checkPointerAddSub(e)) and
  //  instancyOperand(e.getAnOperand())
  instancyOperand(e)
 }


 predicate checkInSensitiveCombinations(Operation e) {
    (binaryCheck(e) and binaryCheck(e.getAnOperand()) and not(checkAddSub(e)) and not(checkSameOperand(e))) or
    // [:bitwise_not :arith_unary] 
    ((e instanceof UnaryBitwiseOperation and checkArithUnary(e.getAnOperand())) or (checkArithUnary(e) and e.getAnOperand() instanceof UnaryBitwiseOperation)) or
    // [:bitwise_not :not] 
    ((e instanceof UnaryBitwiseOperation and e.getAnOperand() instanceof UnaryLogicalOperation) or (e instanceof UnaryLogicalOperation and e.getAnOperand() instanceof UnaryBitwiseOperation)) or
    // [:bitwise_not :pointer]
    ((e instanceof UnaryBitwiseOperation and checkPointer(e.getAnOperand())) or (checkPointer(e) and e.getAnOperand() instanceof UnaryBitwiseOperation)) or
    // [:bitwise_bin :compare] [:bitwise_bin :pointer]
    ((e instanceof BinaryBitwiseOperation and checkPointerCompare(e.getAnOperand())) or (checkPointerCompare(e) and e.getAnOperand() instanceof BinaryBitwiseOperation))
    // TODO:[:bitwise_bin :non-asso]
 }

 predicate checkSensitiveCombinations(Operation e) {
  // [:pointer :de_incr]
  (checkPointer(e) and e.getAnOperand() instanceof CrementOperation) or
  //  [:arith_unary :add] [:arith_unary :multiply] [:arith_unary :and] [:arith_unary :or] [:arith_unary :cond] [:arith_unary :non-asso] [:arith_unary :bitwise_bin]
  (checkArithUnary(e) and checkArithUnaryInsesCompanion(e.getAnOperand())) or
  // [:not :add] [:not :multiply] [:not :and] [:not :or] [:not :compare] [:not :cond] [:not :non-asso] [:not :bitwise_bin]
  (e instanceof UnaryLogicalOperation and checkLogicUnaryInsesCompanion(e.getAnOperand())) or
  // [:pointer :add]
  (checkPointer(e) and e.getAnOperand() instanceof AddExpr) or
  // [:and :cond] [:or :cond] [:not :cond] [:compare :cond] [:bitwise_not :cond] [:bitwise_bin :cond]
  (checkCondInsesCompanion(e) and e.getAnOperand() instanceof ConditionalExpr) or
  // [:bitwise_not :add] [:bitwise_not :multiply] [:bitwise_not :or] [:bitwise_not :cond] [:bitwise_not :compare] [:bitwise_not :non-asso] [:bitwise_not :de_incr] [:bitwise_not :bitwise_bin]
  (e instanceof UnaryBitwiseOperation and checkBitNotInsesCompanion(e.getAnOperand())) or
  // pointer/addr -> PointerFieldAccess
  (checkPointer(e) and e.getAnOperand() instanceof PointerFieldAccess)
 }








 predicate checkBitNotInsesCompanion(Operation e) {
  binaryCheck(e) or
  e instanceof ConditionalExpr or
  e instanceof ComparisonOperation or
  e instanceof CrementOperation
 }


 predicate checkCondInsesCompanion(Operation e) {
  e instanceof BinaryLogicalOperation or
  e instanceof UnaryLogicalOperation or
  e instanceof ComparisonOperation or
  e instanceof BinaryBitwiseOperation or
  e instanceof UnaryBitwiseOperation
 }


 predicate checkLogicUnaryInsesCompanion(Operation e) {
  binaryCheck(e) or
  e instanceof ConditionalExpr or
  e instanceof ComparisonOperation
 }



 predicate checkArithUnaryInsesCompanion(Operation e) {
  binaryCheck(e) or
  e instanceof ConditionalExpr
 }


 predicate checkPointerCompare(Operation e) {
  checkPointer(e) or e instanceof ComparisonOperation
 }


 predicate checkPointer(UnaryOperation e) {
  e instanceof AddressOfExpr or
  e instanceof PointerDereferenceExpr  
 }



predicate checkArithUnary(UnaryArithmeticOperation e) {
  e instanceof UnaryMinusExpr or e instanceof UnaryPlusExpr
}

predicate binaryCheck(Operation e) {
  e instanceof BinaryArithmeticOperation or
  e instanceof BinaryBitwiseOperation or
  e instanceof BinaryLogicalOperation
}



 predicate instancyOperand(Operation e) {
   not((e.getAnOperand().getFullyConverted() instanceof ParenthesisExpr) or
   (e.getAnOperand().getFullyConverted() instanceof CStyleCast and cstyleExpr(e.getAnOperand().getFullyConverted())))
  //  and not(e.isAffectedByMacro())
  and not(e.isInMacroExpansion())
 }


 predicate cstyleExpr(CStyleCast e) {
   e.getExpr() instanceof ParenthesisExpr
 }


 predicate checkSameOperand(Operation e) {
   e.getAnOperand().toString() = e.toString()
 }



 predicate checkAddSub(BinaryArithmeticOperation e) {
   (e instanceof SubExpr or e instanceof AddExpr or e instanceof PointerArithmeticOperation) and
   (e.getLeftOperand() instanceof SubExpr or e.getLeftOperand() instanceof AddExpr or e.getLeftOperand() instanceof PointerArithmeticOperation or
   e.getRightOperand() instanceof SubExpr or e.getRightOperand() instanceof AddExpr or e.getRightOperand() instanceof PointerArithmeticOperation)
 }



 predicate checkPointerAddSub(BinaryArithmeticOperation e) {
   (e instanceof PointerSubExpr or e instanceof PointerAddExpr or e instanceof PointerDiffExpr) //and
   // e.getLeftOperand() instanceof PointerSubExpr or e.getLeftOperand() instanceof PointerAddExpr or
   // e.getRightOperand() instanceof PointerSubExpr or e.getRightOperand() instanceof PointerAddExpr
 }


//  predicate testy_assign(AssignExpr e) {
//    instancy(e.getLValue()) or instancy(e.getRValue())  
//  }



//  predicate testy_comp(ComparisonOperation e) {
   
//  }
 
 
 predicate testy_unary(UnaryOperation e) {
    e instanceof CrementOperation or instancy(e.getOperand())
 }
 
 
 predicate testy(BinaryOperation e) {
   instancy(e.getLeftOperand()) or instancy(e.getRightOperand())
   // e instanceof BinaryBitwiseOperation
    //  not(e instanceof ComparisonOperation) and
    //  (not(e instanceof BinaryLogicalOperation or e instanceof BinaryBitwiseOperation) or 
    //  instancy(e.getLeftOperand()) and
    //  instancy(e.getRightOperand()))
 }
 
 
 from Operation e
 where instancy(e)
 select e, "This is an Operator Precedence atom"
// select e, e.getAChild().toString()