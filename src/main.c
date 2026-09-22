// File: src/main.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mystfunctions.h"
#include "myfilefunctions.h"

int main() {
    printf("--- Testing String Functions ---\n");
    
    const char* test_str = "Hello, World!";
    printf("mystrlen(\"%s\") = %d\n", test_str, mystrlen(test_str));
    
    char dest[50];
    int copied = mystrcpy(dest, test_str);
    printf("mystrcpy: copied \"%s\" (%d chars)\n", dest, copied);
    
    char dest2[50];
    mystrncpy(dest2, "Hello", 10);
    printf("mystrncpy: \"%s\"\n", dest2);
    
    char dest3[50] = "Hello, ";
    mystrcat(dest3, "World!");
    printf("mystrcat: \"%s\"\n", dest3);
    
    printf("\n--- Testing File Functions ---\n");
    
    FILE* fp = fopen("src/main.c", "r");
    if (fp != NULL) {
        int lines, words, chars;
        if (wordCount(fp, &lines, &words, &chars) == 0) {
            printf("wordCount: lines=%d, words=%d, chars=%d\n", lines, words, chars);
        }
        fclose(fp);
    } else {
        printf("Could not open src/main.c for wordCount test\n");
    }
    
    fp = fopen("src/main.c", "r");
    if (fp != NULL) {
        char* matches[100];
        int match_count = mygrep(fp, "printf", matches);
        printf("mygrep found %d lines containing 'printf':\n", match_count);
        for (int i = 0; i < match_count && i < 5; i++) {
            printf("  %s", matches[i]);
            free(matches[i]);
        }
        fclose(fp);
    }
    
    return 0;
}
