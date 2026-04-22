import pkg/questionable/results
import pkg/chronos
import pkg/asynctest/chronos/unittest

{.experimental: "parallel".}

suite "chronos":
  var asyncSuccessCalled: bool
  var asyncFailureCalled: bool
  var assignValueCalled: bool
  var assignValueFailedCalled: bool
  var returnBoolCalled: bool

  setup:
    asyncSuccessCalled = false
    asyncFailureCalled = false
    assignValueCalled = false
    assignValueFailedCalled = false
    returnBoolCalled = false

  proc asyncSuccess(): Future[?!int] {.async.} =
    asyncSuccessCalled = true
    success 42

  proc asyncFailure(): Future[?!int] {.async.} =
    asyncFailureCalled = true
    failure "failed to complete async operation"

  proc assignValue(): ?!int =
    assignValueCalled = true
    success 43

  proc assignValueFailed(): ?!int =
    assignValueFailedCalled = true
    failure "failed to assign value"

  proc returnBool(val: bool): bool =
    returnBoolCalled = true
    return val

  test "=? works with if + await":
    if a =? (await asyncSuccess()):
      check a == 42
    else:
      fail()

  test "=? works with if + await + value binding (and)":
    if a =? (await asyncSuccess()) and b =? assignValue():
      check a == 42
      check b == 43
    else:
      fail()

  test "=? works with if + await failure + value binding -- short circuit doesn't works (and)":
    if a =? (await asyncFailure()) and b =? assignValue():
      fail()

    check assignValueCalled # should not be called if short circuiting works for statement list expressions

  test "=? works with if + await failure + non-statement list expression -- short circuit works (and)":
    if a =? (await asyncFailure()) and returnBool(true):
      fail()

    check not returnBoolCalled

  test "=? works with if + value binding + await (and)":
    if a =? assignValue() and b =? (await asyncSuccess()):
      check a == 43
      check b == 42
    else:
      fail()

  test "=? works with if + value binding + await -- short circuit works (and)":
    if a =? assignValueFailed() and b =? (await asyncSuccess()):
      fail()
    check asyncSuccessCalled # should not be called if short circuiting works for statement list expressions

  test "=? works with if + await + value binding (or)":
    if a =? (await asyncSuccess()) or b =? assignValue():
      check a == 42
      check b == 43
    else:
      fail()

  test "=? works with if + value binding + await -- short circuit doesn't work (or)":
    if a =? assignValue() or b =? (await asyncSuccess()):
      check a == 43
      check b == 42
      check asyncSuccessCalled # should not be called if short circuiting worked for statement list expressions
    else:
      fail()

  test "=? works with if + value binding + non-statement list expression -- short circuit works (or)":
    if a =? assignValue() or returnBool(true):
      check a == 43
      check not returnBoolCalled
    else:
      fail()

  test "=? works with if + value binding failure + await (or)":
    if a =? assignValueFailed() or b =? (await asyncSuccess()):
      check a == default int
      check b == 42
    else:
      fail()


