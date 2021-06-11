/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * In addition, as a special exception, the copyright holders give
 * permission to link the code of portions of this program with the
 * OpenSSL library under certain conditions as described in each
 * individual source file, and distribute linked combinations
 * including the two.
 *
 * You must obey the GNU Affero General Public License in all respects
 * for all of the code used other than OpenSSL.  
 */


#include "config.h"

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#include "monit.h"
#include "Color.h"
#include "Box.h"

// libmonit
#include "util/Str.h"


/**
 * Implementation of the Terminal table interface using UTF-8 box:
 * http://www.unicode.org/charts/PDF/U2500.pdf
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


/* ------------------------------------------------------------ Definitions */


#define BOX_HORIZONTAL          "\u2500" // ─
#define BOX_HORIZONTAL_DOWN     "\u252c" // ┬
#define BOX_VERTICAL            "\u2502" // │
#define BOX_VERTICAL_HORIZONTAL "\u253c" // ┼
#define BOX_VERTICAL_RIGHT      "\u251c" // ├
#define BOX_VERTICAL_LEFT       "\u2524" // ┤
#define BOX_DOWN_RIGHT          "\u250c" // ┌
#define BOX_DOWN_LEFT           "\u2510" // ┐
#define BOX_UP_HORIZONTAL       "\u2534" // ┴
#define BOX_UP_RIGHT            "\u2514" // └
#define BOX_UP_LEFT             "\u2518" // ┘


#define T Box_T
struct T {
        struct {
                unsigned row;
                unsigned column;
        } index;
        struct {
                struct {
                        boolean_t enabled;
                        char *color;
                } header;
        } options;
        unsigned columnsCount;
        BoxColumn_T *columns;
        StringBuffer_T b;
};


/* ------------------------------------------------------- Private Methods */


static void _printBorderTop(T t) {
        StringBuffer_append(t->b, COLOR_DARKGRAY BOX_DOWN_RIGHT BOX_HORIZONTAL);
        for (int i = 0; i < t->columnsCount; i++) {
                for (int j = 0; j < t->columns[i].width; j++)
                        StringBuffer_append(t->b, BOX_HORIZONTAL);
                if (i < t->columnsCount - 1)
                        StringBuffer_append(t->b, BOX_HORIZONTAL BOX_HORIZONTAL_DOWN BOX_HORIZONTAL);
        }
        StringBuffer_append(t->b, BOX_HORIZONTAL BOX_DOWN_LEFT COLOR_RESET "\n");
}


static void _printBorderMiddle(T t) {
        StringBuffer_append(t->b, COLOR_DARKGRAY BOX_VERTICAL_RIGHT BOX_HORIZONTAL);
        for (int i = 0; i < t->columnsCount; i++) {
                for (int j = 0; j < t->columns[i].width; j++)
                        StringBuffer_append(t->b, BOX_HORIZONTAL);
                if (i < t->columnsCount - 1)
                        StringBuffer_append(t->b, BOX_HORIZONTAL BOX_VERTICAL_HORIZONTAL BOX_HORIZONTAL);
        }
        StringBuffer_append(t->b, BOX_HORIZONTAL BOX_VERTICAL_LEFT COLOR_RESET "\n");
}


static void _printBorderBottom(T t) {
        StringBuffer_append(t->b, COLOR_DARKGRAY BOX_UP_RIGHT BOX_HORIZONTAL);
        for (int i = 0; i < t->columnsCount; i++) {
                for (int j = 0; j < t->columns[i].width; j++)
                        StringBuffer_append(t->b, BOX_HORIZONTAL);
                if (i < t->columnsCount - 1)
                        StringBuffer_append(t->b, BOX_HORIZONTAL BOX_UP_HORIZONTAL BOX_HORIZONTAL);
        }
        StringBuffer_append(t->b, BOX_HORIZONTAL BOX_UP_LEFT COLOR_RESET "\n");
}


static void _printHeader(T t) {
        for (int i = 0; i < t->columnsCount; i++) {
                StringBuffer_append(t->b, COLOR_DARKGRAY BOX_VERTICAL COLOR_RESET " ");
                StringBuffer_append(t->b, "%s%-*s%s", t->options.header.color, t->columns[i].width, t->columns[i].name, COLOR_RESET);
                StringBuffer_append(t->b, " ");
        }
        StringBuffer_append(t->b, COLOR_DARKGRAY BOX_VERTICAL COLOR_RESET "\n");
        t->index.row++;
}


static void _cacheColor(BoxColumn_T *column) {
        boolean_t ansi = false;
        if (column->value) {
                for (int i = 0, k = 0; column->value[i]; i++) {
                        if (column->value[i] == '\033' && column->value[i + 1] == '[') {
                                // Escape sequence start
                                column->_color[k++] = '\033';
                                column->_color[k++] = '[';
                                i++;
                                ansi = true;
                        } else if (ansi) {
                                column->_color[k++] = column->value[i];
                                // Escape sequence stop
                                if (column->value[i] >= 64 && column->value[i] <= 126)
                                        break;
                        }
                }
        }
}


// Print a row. If wrap is enabled and the text excceeds width, return true (printed text up to column width, repetition possible to print the rest), otherwise false
static boolean_t _printRow(T t) {
        boolean_t repeat = false;
        for (int i = 0; i < t->columnsCount; i++) {
                StringBuffer_append(t->b, COLOR_DARKGRAY BOX_VERTICAL COLOR_RESET " ");
                if (*(t->columns[i]._color))
                        StringBuffer_append(t->b, "%s", t->columns[i]._color);
                if (! t->columns[i].value || t->columns[i]._cursor > strlen(t->columns[i].value) - 1) {
                        // Empty column pading
                        StringBuffer_append(t->b, "%*s", t->columns[i].width, " ");
                } else if (strlen(t->columns[i].value + t->columns[i]._cursor) > t->columns[i].width) {
                        if (t->columns[i].wrap) {
                                // The value exceeds the column width and should be wrapped
                                int column = 0;
                                for (; t->columns[i].value[t->columns[i]._cursor] && (column == 0 || t->columns[i]._cursor % t->columns[i].width > 0); t->columns[i]._cursor++, column++)
                                        StringBuffer_append(t->b, "%c", t->columns[i].value[t->columns[i]._cursor]);
                                if (t->columns[i]._cursor < t->columns[i]._valueLength)
                                        repeat = true;
                        } else {
                                // The value exceeds the column width and should be truncated
                                Str_trunc(t->columns[i].value, t->columns[i].width);
                                StringBuffer_append(t->b, t->columns[i].align == BoxAlign_Right ? "%*s" : "%-*s", t->columns[i].width, t->columns[i].value);
                                t->columns[i]._cursor = t->columns[i]._valueLength;
                        }
                } else {
                        // The whole value fits in the column width
                        StringBuffer_append(t->b, t->columns[i].align == BoxAlign_Right ? "%*s" : "%-*s", t->columns[i].width, t->columns[i].value + t->columns[i]._cursor);
                        t->columns[i]._cursor = t->columns[i]._valueLength;
                }
                StringBuffer_append(t->b, " ");
                if (*(t->columns[i]._color))
                        StringBuffer_append(t->b, COLOR_RESET);
        }
        StringBuffer_append(t->b, COLOR_DARKGRAY BOX_VERTICAL COLOR_RESET "\n");
        t->index.row++;
        return repeat;
}


static void _resetColumn(BoxColumn_T *column) {
        FREE(column->value);
        column->_cursor = column->_colorLength = column->_valueLength = 0;
        memset(column->_color, 0, sizeof(column->_color));
}


static void _resetRow(T t) {
        for (int i = 0; i < t->columnsCount; i++)
                _resetColumn(&(t->columns[i]));
}


/* -------------------------------------------------------- Public Methods */


T Box_new(StringBuffer_T b, int columnsCount, BoxColumn_T *columns, boolean_t printHeader) {
        ASSERT(b);
        ASSERT(columns);
        ASSERT(columnsCount > 0);
        T t;
        NEW(t);
        t->b = b;
        t->columnsCount = columnsCount;
        t->columns = columns;
        // Default options
        t->options.header.color = COLOR_BOLDCYAN; // Note: hardcoded, option setting can be implemented if needed
        // Options
        t->options.header.enabled = printHeader;
        return t;
}


void Box_free(T *t) {
        ASSERT(t && *t);
        if ((*t)->index.row > 0)
                _printBorderBottom(*t);
        for (int i = 0; i < (*t)->columnsCount; i++)
                FREE((*t)->columns[i].value);
        FREE(*t);
}


void Box_setColumn(T t, int index, const char *format, ...) {
        ASSERT(t);
        ASSERT(index > 0);
        ASSERT(index <= t->columnsCount);
        int _index = index - 1;
        _resetColumn(&(t->columns[_index]));
        if (format) {
                va_list ap;
                va_start(ap, format);
                t->columns[_index].value = Str_vcat(format, ap);
                va_end(ap);
                if ((t->columns[_index]._colorLength = Color_length(t->columns[_index].value))) {
                        _cacheColor(&(t->columns[_index]));
                        Color_strip(t->columns[_index].value); // Strip the escape sequences, so we can safely break the line
                }
                t->columns[_index]._valueLength = strlen(t->columns[_index].value);
        }
}


void Box_printRow(T t) {
        ASSERT(t);
        if (t->index.row == 0) {
                _printBorderTop(t);
                if (t->options.header.enabled) {
                        _printHeader(t);
                        _printBorderMiddle(t);
                }
        } else {
                _printBorderMiddle(t);
        }
        boolean_t repeat = false;
        do {
                repeat = _printRow(t);
        } while (repeat);
        _resetRow(t);
}


char *Box_strip(char *s) {
        if (STR_DEF(s)) {
                int x, y;
                unsigned char *_s = (unsigned char *)s;
                boolean_t separator = false;
                for (x = 0, y = 0; s[y]; y++) {
                        if (! separator) {
                                if (_s[y] == 0xE2 && _s[y + 1] == 0x94) {
                                        if (_s[y + 2] == 0x8c || _s[y + 2] == 0x94 || _s[y + 2] == 0x9c)
                                                separator = true; // Drop the whole separator line
                                        else if (_s[y + 2] >= 0x80 && _s[y + 2] <= 0xBF)
                                                y += 2; // to skip 3 characters of UTF-8 box drawing character
                                } else {
                                        _s[x++] = _s[y];
                                }
                        } else if (_s[y] == '\n') {
                                separator = false;
                        }
                }
                _s[x] = 0;
        }
        return s;
}

