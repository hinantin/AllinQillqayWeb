/*     Foma: a finite-state toolkit and library.                             */
/*     Copyright © 2008-2010 Mans Hulden                                     */

/*     This file is part of foma.                                            */

/*     Foma is free software: you can redistribute it and/or modify          */
/*     it under the terms of the GNU General Public License version 2 as     */
/*     published by the Free Software Foundation.                            */

/*     Foma is distributed in the hope that it will be useful,               */
/*     but WITHOUT ANY WARRANTY; without even the implied warranty of        */
/*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         */
/*     GNU General Public License for more details.                          */

/*     You should have received a copy of the GNU General Public License     */
/*     along with foma.  If not, see <http://www.gnu.org/licenses/>.         */

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <getopt.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <time.h> 
#include "fomalib.h"

#define LINE_LIMIT 262144
#define FLOOKUP_PORT 7891
#define DIR_UP 1
#define UDP_MAX 65535

char *usagestring = "Usage: fmed [-l med_limit] [-c cutoff] <binary foma file>\n";
char *helpstring = "Applies med search (spellcheck) to words from stdin to a foma automaton read from a file\nOptions:\n-h\t\tprint help\n-l med_limit\tset maximum number of suggestions (default is 5)\n-c cutoff\tset maximum levenshtein distance for suggestions (default is 15)";

static struct fsm *net;
//static struct apply_handle *ah;
static struct apply_med_handle *medh;
static FILE *INFILE;
static int port_number = FLOOKUP_PORT;
struct sockaddr_in serv_addr;

int main(int argc, char *argv[]) {
    int opt = 1;
    char *infilename, line[LINE_LIMIT], *result, *separator = "\t";


    extern g_med_limit;
    extern g_med_cutoff;

    while ((opt = getopt(argc, argv, "l:c:P:h")) != -1) {
        switch(opt) {
        case 'l':
	   if(atoi(optarg) == 0)
	    {
	     printf("Maximum number of suggestions can not be zero! Using default value (5).\n");
	     //because med search won't terminate with g_med_limit = 0*/
	      break;
	    }
	   else
	   {
	    g_med_limit = atoi(optarg);
	    break;
	   }
        case 'c':
	   g_med_cutoff = atoi(optarg);
	  break;
	case 'h':
	    printf("%s%s\n", usagestring,helpstring);
            exit(0);
        case 'P':
            port_number = atoi(optarg);
            break;
	default:
            fprintf(stderr, "%s", usagestring);
            exit(EXIT_FAILURE);
    }}

    infilename = argv[optind];
    net = fsm_read_binary_file(infilename);
    if (net == NULL) {
	fprintf(stderr, "%s: %s\n", "File error", infilename);
	exit(EXIT_FAILURE);
    }
    medh = apply_med_init(net);
    apply_med_set_heap_max(medh,4194304+1);
    apply_med_set_med_limit(medh,g_med_limit);
    apply_med_set_med_cutoff(medh,g_med_cutoff);

    //########################################//
    int listenfd = 0, connfd = 0;
    int byte_count;
    char sendBuff[1025];


    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&serv_addr, '0', sizeof (serv_addr));
    memset(sendBuff, '0', sizeof (sendBuff));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(port_number);

    // bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    /* Now bind the host address using bind() call.*/
    if (bind(listenfd, (struct sockaddr*) &serv_addr, sizeof (serv_addr)) < 0) {
        perror("ERROR on binding");
        exit(1);
    } else {
        printf("started server on port %d\n", port_number);
    }

    listen(listenfd, 10);

    while (1) {
        connfd = accept(listenfd, (struct sockaddr*) NULL, NULL);
        // fork child
        //int pid = fork();
        //if (pid < 0) {
        //    perror("ERROR could not fork");
        //    exit(1);
        //}
        //if (pid == 0) {
            /* This is the client process */
            //close(listenfd);
            do {
                byte_count = recv(connfd, sendBuff, 16384, 0);
                if (byte_count < 0) {
                  perror("ERROR reading from socket");
                  //exit(1);
                } else {
                  sendBuff[byte_count] = '\0';
                  char *line = concat(sendBuff, "");
                  char *outstring = handle_line(line);
                  write(connfd, outstring, strlen(outstring));
                }
            } while (byte_count > 0);
            //exit(0);
        //} else {
        //    close(connfd);
        //}

    }

    close(connfd);
    sleep(1);
    //########################################//
    if (medh != NULL) {
	apply_med_clear(medh);
    }
    if (net != NULL) {
	fsm_destroy(net);
    }
    exit(0);
}

char *handle_line(char *s) {
    char *result, *tempstr, *outstr;
    int normalized = 0;
    char *line = concat(s, "");
    outstr = "";
    /* make sure the string is not empty */
    if (line[0] != '\0') {
        /* Apply analyzer.bin */
        result = apply_med(medh, line);
        /* if no result from analyzer, spell check this word with normalizer */
        if (result == NULL) {
          outstr = concat(outstr, "???");
        }            /* word was recognized by analyzer.bin */
        else {
          /*Concat first result*/
          tempstr = concat(line, "\"");
          tempstr = concat(tempstr, result);
          tempstr = concat(tempstr, "\", ");
          outstr = concat(outstr, tempstr);
          /*Concat the rest of the results (if there are more of them)*/
          while ((result = apply_up(ah,NULL)) != NULL) {
            tempstr = concat(line, "\"");
            tempstr = concat(tempstr, result);
            tempstr = concat(tempstr, "\", ");
            outstr = concat(outstr, tempstr);
          }
        }
    }
    return outstr;
}

char* concat_outstr(char *s1, char *s3) {
    char *s2 = ":\n \t";
    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);
    size_t len3 = strlen(s3);
    char *result = malloc(len1 + len2 + len3 + 1); //+1 for the zero-terminator
    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2); //+1 to copy the null-terminator
    memcpy(result + len1 + len2, s3, len3 + 1);
    return result;
}

char* concat_med(char *s1, char *s2, char *s3) {

    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);
    size_t len3 = strlen(s3);
    char *result = malloc(len1 + len2 + len3 + 1); //+1 for the zero-terminator
    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2); //+1 to copy the null-terminator
    memcpy(result + len1 + len2, s3, len3 + 1);
    return result;
}

char* concat(char *s1, char *s2) {

    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);
    char *result = malloc(len1 + len2 + 1); //+1 for the zero-terminator
    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2 + 1); //+1 to copy the null-terminator
    return result;
}
