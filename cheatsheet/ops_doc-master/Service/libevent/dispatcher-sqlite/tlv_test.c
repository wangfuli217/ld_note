#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "tlv.h"
#include "unit.h"

struct sdata {
    char buf[50];
    int id;
    double i;
};

char *tlv_pack_struct_test () {
    struct sdata pack_data = {
        "$heLloWorld#s!",
        50,
        3.6
    };
    struct sdata unpack_data;
    char pack_buf[1024] = { 0 };

    tlv_t ntlv;
    tlv_t *tlv = tlv_new (1, TLV_TYPE_BYTES, sizeof (pack_data), (uint8_t *) & pack_data);
    tlv_pack (tlv, pack_buf, tlv_get_packed_size (tlv));
    ph_debug ("%s", pack_buf);
    if (tlv_unpack (&ntlv, pack_buf, 1024) < 0) {
        return "pack error!";
    }
    ph_debug ("tlv.length=%d", tlv->length);
    ph_debug ("ntlv.length=%d", ntlv.length);
    memcpy ((char *) &unpack_data, ntlv.value, ntlv.length);

    ph_debug ("%s", unpack_data.buf);
    ph_debug ("%d", unpack_data.id);
    ph_debug ("%f", unpack_data.i);

    tlv_free (tlv);

    return NULL;
}

char *run_all_tests () {
    ph_suite_start ();
    ph_run_test (tlv_pack_struct_test);

    return NULL;
}

PH_RUN_TESTS (run_all_tests);
