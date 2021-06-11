-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.i18n", package.seeall)
require("luci.util")

local tparser = require "luci.template.parser"

table   = {}
i18ndir = luci.util.libpath() .. "/i18n/"
loaded  = {}
context = luci.util.threadlocal()
default = "en"

-- + Clear the translation table.
function clear()
end

-- + Load a translation and copy its data into the translation table.
-- # file: Language file
-- # lang: Two-letter language code
-- # force: Force reload even if already loaded (optional)
-- $ Success status
function load(file, lang, force)
end

-- Alternatively load the translation of the fallback language.
-- + Load a translation file using the default translation language. Alternatively load the translation of the fallback language.
-- # file: Language file
-- # force: Force reload even if already loaded (optional)
-- $ 
function loadc(file, force)
end

-- + Set the context default translation language.
-- $ lang: Two-letter language code
function setlanguage(lang)
	context.lang   = lang:gsub("_", "-")
	context.parent = (context.lang:match("^([a-z][a-z])_"))
	if not tparser.load_catalog(context.lang, i18ndir) then
		if context.parent then
			tparser.load_catalog(context.parent, i18ndir)
			return context.parent
		end
	end
	return context.lang
end

-- + Return the translated value for a specific translation key.
-- # key: Default translation text
-- $ Translated string
function translate(key)
	return tparser.translate(key) or key
end

-- + Return the translated value for a specific translation key and use it as sprintf pattern.
-- # key: Default translation text
-- # ...: Format parameters
-- $ Translated and formatted string
function translatef(key, ...)
	return tostring(translate(key)):format(...)
end

-- and ensure that the returned value is a Lua string value.
-- This is the same as calling <code>tostring(translate(...))</code>
-- + Return the translated value for a specific translation key and ensure that the returned value is a Lua string value. This is the same as calling tostring(translate(...))
-- # key: Default translation text
-- $ Translated string
function string(key)
	return tostring(translate(key))
end

-- Ensure that the returned value is a Lua string value.
-- This is the same as calling <code>tostring(translatef(...))</code>
-- + Return the translated value for a specific translation key and use it as sprintf pattern. Ensure that the returned value is a Lua string value. This is the same as calling tostring(translatef(...))
-- # key: Default translation text
-- # ...: Format parameters
-- $ Translated and formatted string
function stringf(key, ...)
	return tostring(translate(key)):format(...)
end
