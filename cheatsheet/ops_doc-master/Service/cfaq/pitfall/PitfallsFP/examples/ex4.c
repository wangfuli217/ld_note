/**
 * Example 4: SIGFPE from integer arithmetic.
 *
 * The compiler is too clever, and it can spot an explicit division by zero
 * (e.g. writing "return 1/0". So we need to fool it by asking to divide by
 * (argc-1) instead, then run with no arguments.
 *
 * This should cause a message such as "Floating point exception" to be
 * printed due to receiving SIGFPE, even though there is no floating point
 * arithmetic going on.
 *
 * See also ex4.S, the assembly of this program, to verify that no floating
 * point instructions are executed. Generated with:
 *
 *   gcc -std=c99 -Werror -Wall -Wextra -S  ex4.c -o ex4.S
 */

int main(int argc, char __attribute__((unused)) **argv)
{
  return 1/(argc-1);
}
