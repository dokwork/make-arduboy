/**
 * The simplest example of the arduboy project.
 */
#include <Arduboy2.h>
#include <Arduino.h>
Arduboy2 arduboy;

void
setup ()
{
  arduboy.begin ();
  arduboy.clear ();
  arduboy.print ("Hello world!");
  arduboy.display ();
}

void
loop ()
{
}
