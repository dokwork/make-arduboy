#include <Arduboy2.h>
#include <Arduino.h>
#include "hello/hello.h"

Arduboy2 arduboy;

void
setup ()
{
  arduboy.begin ();
  arduboy.clear ();
  arduboy.print (say_hello());
  arduboy.display ();
}

void
loop ()
{
}
