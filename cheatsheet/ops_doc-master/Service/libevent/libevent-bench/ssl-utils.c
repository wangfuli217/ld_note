/*
 * Copyright (c) 2010 Christopher Davis
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/* Much of this is adapted from regress_ssl.c unit test: */
/*
 * Copyright (c) 2009-2010 Niels Provos and Nick Mathewson
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */



#include <time.h>

#include <openssl/ssl.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <openssl/pem.h>

#include "ssl-utils.h"

/* A short pre-generated key, to save the cost of doing an RSA key generation
 * step during the unit tests.  It's only 512 bits long, and it is published
 * in this file, so you would have to be very foolish to consider using it in
 * your own code. */
static const char KEY[] =
    "-----BEGIN RSA PRIVATE KEY-----\n"
    "MIIBOgIBAAJBAKibTEzXjj+sqpipePX1lEk5BNFuL/dDBbw8QCXgaJWikOiKHeJq\n"
    "3FQ0OmCnmpkdsPFE4x3ojYmmdgE2i0dJwq0CAwEAAQJAZ08gpUS+qE1IClps/2gG\n"
    "AAer6Bc31K2AaiIQvCSQcH440cp062QtWMC3V5sEoWmdLsbAHFH26/9ZHn5zAflp\n"
    "gQIhANWOx/UYeR8HD0WREU5kcuSzgzNLwUErHLzxP7U6aojpAiEAyh2H35CjN/P7\n"
    "NhcZ4QYw3PeUWpqgJnaE/4i80BSYkSUCIQDLHFhLYLJZ80HwHTADif/ISn9/Ow6b\n"
    "p6BWh3DbMar/eQIgBPS6azH5vpp983KXkNv9AL4VZi9ac/b+BeINdzC6GP0CIDmB\n"
    "U6GFEQTZ3IfuiVabG5pummdC4DNbcdI+WKrSFNmQ\n"
    "-----END RSA PRIVATE KEY-----\n";

void
ssl_init(void)
{
	SSL_library_init();
	ERR_load_crypto_strings();
	SSL_load_error_strings();
	OpenSSL_add_all_algorithms();
}

EVP_PKEY *
ssl_build_key(void)
{
	EVP_PKEY *key;
	BIO *bio;

	/* new read-only BIO backed by KEY. */
	bio = BIO_new_mem_buf((char*)KEY, -1);
	if (!bio)
		return NULL;

	key = PEM_read_bio_PrivateKey(bio,NULL,NULL,NULL);
	BIO_free(bio);
	if (!key)
		return NULL;

	return key;
}

X509 *
ssl_build_cert(EVP_PKEY *key)
{
	/* Dummy code to make a quick-and-dirty valid certificate with
	   OpenSSL.  Don't copy this code into your own program! It does a
	   number of things in a stupid and insecure way. */
	X509 *x509 = NULL;
	X509_NAME *name = NULL;
	int nid;
	time_t now = time(NULL);

	x509 = X509_new();
	if (!x509)
		return NULL;
	if (X509_set_version(x509, 2) == 0)
		goto out;
	if (ASN1_INTEGER_set(X509_get_serialNumber(x509),
		(long)now) == 0)
		goto out;

	name = X509_NAME_new();
	if (!name)
		goto out;
	nid = OBJ_txt2nid("commonName");
	if (NID_undef == nid)
		goto out;
	if (0 == X509_NAME_add_entry_by_NID(
		    name, nid, MBSTRING_ASC, (unsigned char*)"bench.net",
		    -1, -1, 0))
		goto out;

	X509_set_subject_name(x509, name);
	X509_set_issuer_name(x509, name);

	X509_time_adj(X509_get_notBefore(x509), 0, &now);
	now += 3600;
	X509_time_adj(X509_get_notAfter(x509), 0, &now);
	X509_set_pubkey(x509, key);
	if (0 == X509_sign(x509, key, EVP_sha1()))
		goto out;

	return x509;
out:
	X509_free(x509);
	return NULL;
}
