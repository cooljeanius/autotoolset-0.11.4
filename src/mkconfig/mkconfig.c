/* mkconfig.c
** Copyright (C) 1998 Eleftherios Gkioulekas <lf@amath.washington.edu>
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
*/

#if HAVE_CONFIG_H
# include <config.h>
#else
# define MKCONFIG_C_NON_AUTOTOOLS_BUILD 1
# if defined(__GNUC__) && !defined(__STRICT_ANSI__)
#  warning "building mkconfig.c without autoheader is unsupported."
# endif /* __GNUC__ && !__STRICT_ANSI__ */
#endif /* HAVE_CONFIG_H */
#include <stdio.h>
#include <long-options.h>
#include <xalloca.h>

#if defined(HAVE_STDLIB_H) && defined(HAVE_EXIT) && !defined(exit)
# include <stdlib.h>
#else
# if defined(__GNUC__) && !defined(__STRICT_ANSI__) && !defined(exit) && !defined(_STDLIB_H_)
#  warning "mkconfig.c needs to include <stdlib.h> for exit()."
# endif /* __GNUC__ && !__STRICT_ANSI__ && !exit && !_STDLIB_H_ */
#endif /* HAVE_STDLIB_H && HAVE_EXIT && !exit */

#if defined(HAVE_STRING_H)
# if (defined(HAVE_STRLEN) && !defined(strlen)) || (defined(HAVE_STRCPY) && !defined(strcpy)) || (defined(HAVE_STRCAT) && !defined(strcat))
#  include <string.h>
# else
#  if defined(__GNUC__) && !defined(__STRICT_ANSI__) && !defined(strlen) && !defined(_STRING_H_)
#   warning "mkconfig.c needs to include <string.h> for strlen()."
#  endif /* __GNUC__ && !__STRICT_ANSI__ && !strlen && !_STRING_H_ */
#  if defined(__GNUC__) && !defined(__STRICT_ANSI__) && !defined(strcpy) && !defined(_STRING_H_)
#   warning "mkconfig.c needs to include <string.h> for strcpy()."
#  endif /* __GNUC__ && !__STRICT_ANSI__ && !strcpy && !_STRING_H_ */
#  if defined(__GNUC__) && !defined(__STRICT_ANSI__) && !defined(strcat) && !defined(_STRING_H_)
#   warning "mkconfig.c needs to include <string.h> for strcat()."
#  endif /* __GNUC__ && !__STRICT_ANSI__ && !strcat && !_STRING_H_ */
# endif /* (HAVE_STRLEN && !strlen) || (HAVE_STRCPY && !strcpy) || (HAVE_STRCAT && !strcat) */
#else
# if defined(__GNUC__) && !defined(__STRICT_ANSI__)
#  warning "mkconfig.c expects <string.h> to be present."
# endif /* __GNUC__ && !__STRICT_ANSI__ && !exit */
#endif /* HAVE_STRING_H */

/* foo_config.txt */
extern int config_txt_length;
extern char *config_txt[];

void usage(int f)
{
#pragma unused (f)
 printf("Usage: mkconfig [FILE]\n"
        "Create a 'foo-config.in' template for a new package.\n"
        "If 'foo' is the name of your package, and you need your package\n"
        "to install a config script, then you must invoke this command\n"
        "with 'foo-config.sh' as the appropriate argument.\n"
        "\n"
        "General Options:\n"
        "  --help              print this help, then exit\n"
        "  --version           print version number, then exit\n"
        "\n"
        "Report bugs to <lf@amath.washington.edu>\n"
       );

}

void usage_error(void)
{
 printf("Usage: mkconfig [FILE]\n"
        "For more information type: mkconfig --help\n");
 exit(1);
}

int main(int argc, char *argv[])
{
 char *filename;
 FILE *file;
 int i;

 parse_long_options(argc, argv, "mkconfig", PACKAGE, VERSION, usage);
 if (argc != 2) {
  usage_error();
 }
 filename = alloca(strlen(argv[1]) + strlen("-config.in") + 1);
 strcpy(filename, argv[1]);
 strcat(filename, "-config.in");
 if ((file = fopen(filename, "w")) == NULL) {
  fprintf(stderr, "Cannot open file %s\n", filename);
  exit(1);
 }
 for ((i = 1); (i < config_txt_length); i++) {
  fprintf(file, "%s\n", config_txt[i]);
 }
 fclose(file);
}

/* EOF */
