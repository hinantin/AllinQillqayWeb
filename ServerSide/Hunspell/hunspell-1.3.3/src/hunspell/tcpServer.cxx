#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <getopt.h>
#include "hunspell.h"

char *usagestring = "Usage: tcpServer <affix file path> <dictionary file path>\n";
char *helpstring = "Applies hunspell spellcheck to words from stdin to a hunspell affix and dictionary read from a file\nOptions:\n-h\t\tprint help\n-l med_limit\tset maximum number of suggestions (default is 5)\n-c cutoff\tset maximum levenshtein distance for suggestions (default is 15)";

int main(int argc, char *argv[]) {
  exit(0);
}
