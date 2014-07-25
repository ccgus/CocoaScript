/*
 
 libMultiMarkdown.h -- MultiMarkdown library header
 
 (c) 2013 Fletcher T. Penney (http://fletcherpenney.net/).
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License or the MIT
 license.  See LICENSE for details.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 */

//#include "parser.h"

/* Main API commands */

char * markdown_to_string(char * source, unsigned long extensions, int format);
bool   has_metadata(char *source, unsigned long extensions);
char * extract_metadata_keys(char *source, unsigned long extensions);
char * extract_metadata_value(char *source, unsigned long extensions, char *key);
char * mmd_version(void);


/* These are the basic extensions */
enum parser_extensions {
	EXT_COMPATIBILITY       = 1 << 0,    /* Markdown compatibility mode */
	EXT_COMPLETE            = 1 << 1,    /* Create complete document */
	EXT_SNIPPET             = 1 << 2,    /* Create snippet only */
	EXT_HEAD_CLOSED         = 1 << 3,    /* for use by parser */
	EXT_SMART               = 1 << 4,    /* Enable Smart quotes */
	EXT_NOTES               = 1 << 5,    /* Enable Footnotes */
	EXT_NO_LABELS           = 1 << 6,    /* Don't add anchors to headers, etc. */
	EXT_FILTER_STYLES       = 1 << 7,    /* Filter out style blocks */
	EXT_FILTER_HTML         = 1 << 8,    /* Filter out raw HTML */
	EXT_PROCESS_HTML        = 1 << 9,    /* Process Markdown inside HTML */
	EXT_NO_METADATA         = 1 << 10,   /* Don't parse Metadata */
	EXT_OBFUSCATE           = 1 << 11,   /* Mask email addresses */
	EXT_CRITIC              = 1 << 12,   /* Critic Markup Support */
	EXT_CRITIC_ACCEPT       = 1 << 13,   /* Accept all proposed changes */
	EXT_CRITIC_REJECT       = 1 << 14,   /* Reject all proposed changes */
	EXT_RANDOM_FOOT         = 1 << 15,   /* Use random numbers for footnote links */
	EXT_HEADINGSECTION      = 1 << 16,   /* Group blocks under parent heading */
	EXT_ESCAPED_LINE_BREAKS = 1 << 17,   /* Escaped line break */
	EXT_FAKE                = 1 << 31,   /* 31 is highest number allowed */
};

/* Define output formats we support -- first in list is default */
enum export_formats {
	HTML_FORMAT,
	TEXT_FORMAT,
	LATEX_FORMAT,
	MEMOIR_FORMAT,
	BEAMER_FORMAT,
	OPML_FORMAT,
	ODF_FORMAT,
	RTF_FORMAT,
	ORIGINAL_FORMAT,                 /* Not currently used */
	CRITIC_ACCEPT_FORMAT,
	CRITIC_REJECT_FORMAT,
	CRITIC_HTML_HIGHLIGHT_FORMAT,
	LYX_FORMAT,
};

/* These are the identifiers for node types */
enum keys {
	NO_TYPE,
	LIST,
	STR,
	APOSTROPHE,
	FOOTER,
	PARA,
	PLAIN,
	LINEBREAK,
	SPACE,
	HEADINGSECTION,
	H1, H2, H3, H4, H5, H6, H7,	/* Keep these in order */
	METADATA,
	METAKEY,
	METAVALUE,
	MATHSPAN,
	STRONG,
	EMPH,
	LINK,
	SOURCE,
	TITLE,
	REFNAME,
	AUTOLABEL,
	IMAGE,
	IMAGEBLOCK,
	NOTEREFERENCE,
	CODE,
	HTML,
	ELLIPSIS,
	ENDASH,
	EMDASH,
	SINGLEQUOTED,
	DOUBLEQUOTED,
	BLOCKQUOTE,
	BLOCKQUOTEMARKER,
	RAW,
	VERBATIM,
	VERBATIMTYPE,
	DEFLIST,
	TERM,
	DEFINITION,
	HRULE,
	ORDEREDLIST,
	BULLETLIST,
	LISTITEM,
	HTMLBLOCK,
	TABLE,
	TABLECAPTION,
	TABLELABEL,
	TABLESEPARATOR,
	TABLECELL,
	CELLSPAN,
	TABLEROW,
	TABLEBODY,
	TABLEHEAD,
	LINKREFERENCE,
	NOTESOURCE,
	CITATIONSOURCE,
	SOURCEBRANCH,
	NOTELABEL,
	ATTRVALUE,
	ATTRKEY,
	GLOSSARYSOURCE,
	GLOSSARYSORTKEY,
	GLOSSARYTERM,
	CITATION,
	NOCITATION,
	CRITICADDITION,
	CRITICDELETION,
	CRITICSUBSTITUTION,
	CRITICHIGHLIGHT,
	CRITICCOMMENT,
	SUPERSCRIPT,
	SUBSCRIPT,
	VARIABLE,
	KEY_COUNTER                      /* This *MUST* be the last item in the list */
};

/* This is the element used in the resulting parse tree */
struct node {
	short             key;           /* what type of element are we? */
	char              *str;          /* relevant string from source for element */
	struct link_data  *link_data;    /* store link info when relevant */
	struct node       *children;     /* child elements */
	struct node       *next;         /* next element */
};

typedef struct node node;
