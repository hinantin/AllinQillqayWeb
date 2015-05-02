#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <getopt.h>
#include "hunspell.h"

char *usagestring = "Usage: tcpServer <affix file path> <dictionary file path>\n";
char *helpstring = "Applies hunspell spellcheck to words from stdin to a hunspell affix and dictionary read from a file\nOptions:\n-h\t\tprint help\n-l med_limit\tset maximum number of suggestions (default is 5)\n-c cutoff\tset maximum levenshtein distance for suggestions (default is 15)";

int main(int argc, char *argv[]) {
  int opt = 1;
  char *affpath, *dpath, **slist;
  int list_size, i;
  
  /* get analyzer binary */
  affpath = argv[optind];
  dpath = argv[optind + 1];
  char const word[256] = "ñawi";
  Hunhandle *pHunspell = Hunspell_create(affpath, dpath);

  if (Hunspell_spell(pHunspell, word)) {
    printf("You are correct!\n");
  }
  else {
    printf("You are incorrect\n");
    list_size = Hunspell_suggest(pHunspell, &slist, word);
    printf("Number of suggestions: %i\n", list_size);
    for (i = 0; i < list_size; i++)
    {
      printf("-%s\n", slist[i]);
    }
  }
  
  Hunspell_destroy(pHunspell);
  exit(0);
}
