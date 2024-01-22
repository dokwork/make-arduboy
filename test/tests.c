#include "unity.h"
#include "hello/hello.h"

void
setUp (void)
{
}

void
tearDown (void)
{
}

static void
test (void)
{
  TEST_ASSERT_EQUAL_STRING("Hello world!", say_hello());
}

int
main (void)
{
  UnityBegin ("test.c");

  RUN_TEST (test);

  return UnityEnd ();
}
