#include "firebert.h"
#include "util.h"
#include "bfmt.h"

// ------------------------------------------------------------ 

// strcmp-sorted

static struct ent { 
	char *e;
	u_short c;
} Ents[] = {
	{	"AElig",	198	},
	{	"Aacute",	193	},
	{	"Acirc",	194	},
	{	"Agrave",	192	},
	{	"Aring",	197	},
	{	"Atilde",	195	},
	{	"Auml",		196	},
	{	"Ccedil",	199	},
	{	"Dagger",	8225	},
	{	"Delta",	916	},
	{	"ETH",		208	},
	{	"Eacute",	201	},
	{	"Ecirc",	202	},
	{	"Egrave",	200	},
	{	"Euml",		203	},
	{	"Iacute",	205	},
	{	"Icirc",	206	},
	{	"Igrave",	204	},
	{	"Iuml",		207	},
	{	"Ntilde",	209	},
	{	"OElig",	338	},
	{	"Oacute",	211	},
	{	"Ocirc",	212	},
	{	"Ograve",	210	},
	{	"Omega",	937	},
	{	"Oslash",	216	},
	{	"Otilde",	213	},
	{	"Ouml",		214	},
	{	"Scaron",	352	},
	{	"THORN",	222	},
	{	"Uacute",	218	},
	{	"Ucirc",	219	},
	{	"Ugrave",	217	},
	{	"Uuml",		220	},
	{	"Yacute",	221	},
	{	"Yuml",		376	},
	{	"aacute",	225	},
	{	"acirc",	226	},
	{	"acute",	180	},
	{	"aelig",	230	},
	{	"agrave",	224	},
	{	"amp",		38	},
	{	"ap",		8773	},
	{	"aring",	229	},
	{	"atilde",	227	},
	{	"auml",		228	},
	{	"breve",	728	},
	{	"brvbar",	166	},
	{	"bull",		8226	},
	{	"caron",	711	},
	{	"ccedil",	231	},
	{	"cedil",	184	},
	{	"cent",		162	},
	{	"circ",		710	},
	{	"copy",		169	},
	{	"curren",	164	},
	{	"dagger",	8224	},
	{	"dblac",	733	},
	{	"deg",		176	},
	{	"divide",	247	},
	{	"dot",		729	},
	{	"eacute",	233	},
	{	"ecirc",	234	},
	{	"egrave",	232	},
	{	"eth",		240	},
	{	"euml",		235	},
	{	"fnof",		402	},
	{	"frac12",	189	},
	{	"frac14",	188	},
	{	"frac34",	190	},
	{	"ge",		8805	},
	{	"gt",		62	},
	{	"hellip",	8230	},
	{	"iacute",	237	},
	{	"icirc",	238	},
	{	"iexcl",	161	},
	{	"igrave",	236	},
	{	"infin",	8734	},
	{	"inodot",	305	},
	{	"int",		8747	},
	{	"iquest",	191	},
	{	"iuml",		239	},
	{	"laquo",	171	},
	{	"ldquo",	8220	},
	{	"ldquor",	8222	},
	{	"le",		8804	},
	{	"loz",		9674	},
	{	"lsaquo",	8249	},
	{	"lsquo",	8216	},
	{	"lsquor",	8218	},
	{	"lt",		60	},
	{	"macr",		175	},
	{	"mdash",	8212	},
	{	"micro",	181	},
	{	"middot",	183	},
	{	"nbsp",		160	},
	{	"ndash",	8211	},
	{	"ne",		8800	},
	{	"not",		172	},
	{	"ntilde",	241	},
	{	"oacute",	243	},
	{	"ocirc",	244	},
	{	"oelig",	339	},
	{	"ogon",		731	},
	{	"ograve",	242	},
	{	"ordf",		170	},
	{	"ordm",		186	},
	{	"oslash",	248	},
	{	"otilde",	245	},
	{	"ouml",		246	},
	{	"para",		182	},
	{	"part",		8706	},
	{	"permil",	8240	},
	{	"pi",		960	},
	{	"plusmn",	177	},
	{	"pound",	163	},
	{	"prod",		8719	},
	{	"quot",		34	},
	{	"radic",	8730	},
	{	"raquo",	187	},
	{	"rdquo",	8221	},
	{	"reg",		174	},
	{	"ring",		730	},
	{	"rsaquo",	8250	},
	{	"rsquo",	8217	},
	{	"scaron",	353	},
	{	"sect",		167	},
	{	"shy",		173	},
	{	"sum",		931	},
	{	"sup1",		185	},
	{	"sup2",		178	},
	{	"sup3",		179	},
	{	"szlig",	223	},
	{	"thorn",	254	},
	{	"tilde",	732	},
	{	"times",	215	},
	{	"trade",	8482	},
	{	"uacute",	250	},
	{	"ucirc",	251	},
	{	"ugrave",	249	},
	{	"uml",		168	},
	{	"uuml",		252	},
	{	"yacute",	253	},
	{	"yen",		165	},
	{	"yuml",		255	},
}, Codes[] = { 
	{	"quot",		34	},
	{	"amp",		38	},
	{	"lt",		60	},
	{	"gt",		62	},
	{	"nbsp",		160	},
	{	"iexcl",	161	},
	{	"cent",		162	},
	{	"pound",	163	},
	{	"curren",	164	},
	{	"yen",		165	},
	{	"brvbar",	166	},
	{	"sect",		167	},
	{	"uml",		168    	},
	{	"copy",		169	},
	{	"ordf",		170	},
	{	"laquo",	171	},
	{	"not",		172	},
	{	"shy",		173	},
	{	"reg",		174	},
	{	"macr",		175	},
	{	"deg",		176	},
	{	"plusmn",	177	},
	{	"sup2",		178	},
	{	"sup3",		179	},
	{	"acute",	180	},
	{	"micro",	181	},
	{	"para",		182	},
	{	"middot",	183	},
	{	"cedil",	184	},
	{	"sup1",		185	},
	{	"ordm",		186	},
	{	"raquo",	187	},
	{	"frac14",	188	},
	{	"frac12",	189	},
	{	"frac34",	190	},
	{	"iquest",	191	},
	{	"Agrave",	192	},
	{	"Aacute",	193	},
	{	"Acirc",	194	},
	{	"Atilde",	195	},
	{	"Auml",		196	},
	{	"Aring",	197	},
	{	"AElig",	198	},
	{	"Ccedil",	199	},
	{	"Egrave",	200	},
	{	"Eacute",	201	},
	{	"Ecirc",	202	},
	{	"Euml",		203	},
	{	"Igrave",	204	},
	{	"Iacute",	205	},
	{	"Icirc",	206	},
	{	"Iuml",		207	},
	{	"ETH",		208	},
	{	"Ntilde",	209	},
	{	"Ograve",	210	},
	{	"Oacute",	211	},
	{	"Ocirc",	212	},
	{	"Otilde",	213	},
	{	"Ouml",		214	},
	{	"times",	215	},
	{	"Oslash",	216	},
	{	"Ugrave",	217	},
	{	"Uacute",	218	},
	{	"Ucirc",	219	},
	{	"Uuml",		220	},
	{	"Yacute",	221	},
	{	"THORN",	222	},
	{	"szlig",	223	},
	{	"agrave",	224	},
	{	"aacute",	225	},
	{	"acirc",	226	},
	{	"atilde",	227	},
	{	"auml",		228	},
	{	"aring",	229	},
	{	"aelig",	230	},
	{	"ccedil",	231	},
	{	"egrave",	232	},
	{	"eacute",	233	},
	{	"ecirc",	234	},
	{	"euml",		235	},
	{	"igrave",	236	},
	{	"iacute",	237	},
	{	"icirc",	238	},
	{	"iuml",		239	},
	{	"eth",		240	},
	{	"ntilde",	241	},
	{	"ograve",	242	},
	{	"oacute",	243	},
	{	"ocirc",	244	},
	{	"otilde",	245	},
	{	"ouml",		246	},
	{	"divide",	247	},
	{	"oslash",	248	},
	{	"ugrave",	249	},
	{	"uacute",	250	},
	{	"ucirc",	251	},
	{	"uuml",		252	},
	{	"yacute",	253	},
	{	"thorn",	254	},
	{	"yuml",		255	},
	{	"inodot",	305	},
	{	"OElig",	338	},
	{	"oelig",	339	},
	{	"Scaron",	352	},
	{	"scaron",	353	},
	{	"Yuml",		376	},
	{	"fnof",		402	},
	{	"circ",		710	},
	{	"caron",	711	},
	{	"breve",	728	},
	{	"dot",		729	},
	{	"ring",		730	},
	{	"ogon",		731	},
	{	"tilde",	732	},
	{	"dblac",	733	},
	{	"Delta",	916	},
	{	"sum",		931	},
	{	"Omega",	937	},
	{	"pi",		960	},
	{	"ndash",	8211	},
	{	"mdash",	8212	},
	{	"lsquo",	8216	},
	{	"rsquo",	8217	},
	{	"lsquor",	8218	},
	{	"ldquo",	8220	},
	{	"rdquo",	8221	},
	{	"ldquor",	8222	},
	{	"dagger",	8224	},
	{	"Dagger",	8225	},
	{	"bull",		8226	},
	{	"hellip",	8230	},
	{	"permil",	8240	},
	{	"lsaquo",	8249	},
	{	"rsaquo",	8250	},
	{	"trade",	8482	},
	{	"part",		8706	},
	{	"prod",		8719	},
	{	"radic",	8730	},
	{	"infin",	8734	},
	{	"int",		8747	},
	{	"ap",		8773	},
	{	"ne",		8800	},
	{	"le",		8804	},
	{	"ge",		8805	},
	{	"loz",		9674	},
};

// ------------------------------------------------------------ 

static int _compe(const void *xv, const void *yv) {
        const struct ent *x = xv, *y = yv;
        return(strcmp(x->e, y->e));
}

// ------------------------------------------------------------ 

static int _compc(const void *xv, const void *yv) {
        const struct ent *x = xv, *y = yv;
	if(x->c < y->c)
		return(-1);
	return(x->c != y->c);
}

// ------------------------------------------------------------ 

static inline size_t 
_ncodes(void) {
	return(sizeof Codes / sizeof Codes[0]);
}

// ------------------------------------------------------------ 

static inline size_t
_nents(void) {
	return(sizeof Ents / sizeof Ents[0]);
}

// ------------------------------------------------------------ 

static inline u_int16_t
_code(char *ent) {
	u_int16_t ret = 0;
       	struct ent *e = NULL, k;

	k.e = ent;
	k.c = 0;

	if((e = bsearch(&k, Ents, _nents(), sizeof(Ents[0]), _compe))) 
		ret = e->c;

	return(ret);
}

// ------------------------------------------------------------ 

static inline char * 
_ent(u_int16_t c) {
	char *ret = NULL;
	struct ent *e = NULL, k;

	k.e = NULL;
	k.c = c;

	if((e = bsearch(&k, Codes, _ncodes(), sizeof(Codes[0]), _compc))) 
		ret = e->e;
	else {
		static char buf[50];
		fmt_sfmt(buf, 50, "#%d", c);
		ret = buf;
	}

	return(ret);
}

// ------------------------------------------------------------ 

u_char *
ascii2unicode(u_char *dst, char *src, size_t *l) {
	u_char *dp = dst, *tp = &dp[*l];
	char *cp = src, *ep = &src[strlen(cp) ];

	while(cp < ep) {
		int w = 0;
		if(cp[0] == '&' && &cp[3] < ep) {
			char *dem = &cp[3];
	
			cp++;
			if(*cp == '#')
	       			cp++;

			while(dem[0] != ';' && !isspace(dem[0]) && dem < ep && dem < &cp[11])
				dem++;

			if(dem[0] == ';') {
				char *ent = nult(cp, dem);
				unsigned code = 0;

				if(isdigit(ent[0])) 
					code = strtoul(ent, NULL, 0);
				else	
					code = _code(ent);

       				lst16((unsigned short)code, &dp, tp);
	       			w = 1;
				cp = dem;
			}
		}

		if(!w) {
			lst8(*cp, &dp, tp);
			lst8(0, &dp, tp);
		}

		cp++;
	}

	*l = (size_t)(dp - dst);
	return(dst);
}

// ------------------------------------------------------------ 

char *
unicode2asc(char *dst, u_char *bp, u_char *ep, size_t *l) {
	char *cp = dst, *tp = &dst[*l] - 1;

	while(&bp[1] < ep && cp < tp) {
		u_int16_t code = lld16(&bp, ep);
		if(isprint(code) || code == '\n' || code == '\r')
			st8((u_char)code, (u_char**)&cp, (u_char*)tp);
		else 
     /*oink*/		cp += fmt_sfmt(cp, (size_t)(tp-cp), "&%s;", _ent(code));
	}

	*cp++ = 0;

	*l = (size_t)(cp - dst);
	return(dst);
}

// ------------------------------------------------------------ 

char *
unicode2ascii(char *dst, char *src, size_t dlen) {
	char *ep = src;
	       
	while(*ep)
		ep += 2;	

	return(unicode2asc(dst, (u_char*)src, (u_char*)ep, &dlen));
}
