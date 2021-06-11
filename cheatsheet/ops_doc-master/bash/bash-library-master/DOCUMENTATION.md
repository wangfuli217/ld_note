# Documentation of 'bin/piwi-bash-library.bash'

## REFERENCES (line 1)


-   **Bash Reference Manual: <http://www.gnu.org/software/bash/manual/bashref.html>**

-   **Bash Guide for Beginners: <http://www.tldp.org/LDP/Bash-Beginners-Guide/html/Bash-Beginners-Guide.html>**

-   **Advanced Bash-Scripting Guide: <http://www.tldp.org/LDP/abs/html/abs-guide.html>**

-   **GNU coding standards: <http://www.gnu.org/prep/standards/standards.html>**

## ENVIRONMENT (line 6)


-   **SCRIPT_VARS = ( NAME VERSION DATE DESCRIPTION LICENSE HOMEPAGE SYNOPSIS OPTIONS ) (read-only)**

	List of variables defined by the caller script used to build all informational strings.

	These are all RECOMMENDED.

-   **USAGE_VARS = ( NAME VERSION DATE DESCRIPTION_USAGE SYNOPSIS_USAGE OPTIONS_USAGE ) (read-only)**

	List of variables defined by the caller script used to build the 'usage' string (common option `--usage`).

-   **USAGE_SUFFIX = "_USAGE"**

	Suffix used to build some of the `USAGE_VARS` variable names ; it is stripped to fallback over "classic" variable.

-   **VERSION_VARS = ( NAME VERSION DATE DESCRIPTION COPYRIGHT LICENSE HOMEPAGE SOURCES ADDITIONAL_INFO ) (read-only)**

	List of variables defined by the caller script used to build the 'version' string (common option `--version`).

	**@see:** <http://www.gnu.org/prep/standards/standards.html#g_t_002d_002dversion>

-   **MANPAGE_VARS = ( NAME VERSION DATE DESCRIPTION_MANPAGE SYNOPSIS_MANPAGE OPTIONS_MANPAGE EXAMPLES_MANPAGE EXIT_STATUS_MANPAGE FILES_MANPAGE ENVIRONMENT_MANPAGE COPYRIGHT_MANPAGE HOMEPAGE_MANPAGE BUGS_MANPAGE AUTHOR_MANPAGE SEE_ALSO_MANPAGE ) (read-only)**

	List of variables defined by the caller script used to build the 'manpage' string (common option `--manpage`).

	**@see:** <http://en.wikipedia.org/wiki/Man_page>

-   **MANPAGE_SUFFIX = "_MANPAGE"**

	Suffix used to build some of the `USAGE_VARS` variable names ; it is stripped to fallback over "classic" variable.

-   **LIB_FLAGS = ( VERBOSE QUIET DEBUG INTERACTIVE FORCED ) (read-only)**

	List of variables defined as global flags ; they are enabled/disabled by common options.

-   **INTERACTIVE = DEBUG = VERBOSE = QUIET = FORCED = DRYRUN = false**

-   **WORKINGDIR = `pwd`**

-   **COLOR_VARS = ( COLOR_LIGHT COLOR_DARK COLOR_INFO COLOR_NOTICE COLOR_WARNING COLOR_ERROR COLOR_COMMENT ) (read-only)**

	List of variables defined by the library as "common colors" names.

-   **USEROS = "$(uname)" (read-only)**

	Current running operating system name.

-   **LINUX_OS = ( Linux FreeBSD OpenBSD SunOS ) (read-only)**

	List of Linux-like OSs.

-   **USERSHELL = "$SHELL" (read-only)**

	Path of the shell currently in use (value of the global `$SHELL` variable).

-   **SHELLVERSION = "$BASH_VERSION" (read-only)**

	Version number of current shell in use (value of the global `$BASH_VERSION` variable).

## SETTINGS (line 36)


-   **E_ERROR=90**

-   **E_OPTS=81**

-   **E_CMD=82**

-   **E_PATH=83**

	Error codes in Bash must return an exit code between 0 and 255.

	In the library, to be conform with C/C++ programs, we will try to use codes from 80 to 120

	(error codes in C/C++ begin at 64 but the recent evolutions of Bash reserved codes 64 to 78).

-   **LIB_FILENAME_DEFAULT = "piwi-bash-library" (read-only)**

-   **LIB_NAME_DEFAULT = "piwibashlib" (read-only)**

-   **LIB_LOGFILE = "piwibashlib.log" (read-only)**

-   **LIB_TEMPDIR = "tmp" (read-only)**

-   **LIB_SYSHOMEDIR = "${HOME}/.piwi-bash-library/" (read-only)**

-   **LIB_SYSCACHEDIR = "${LIB_SYSHOMEDIR}/cache/" (read-only)**

## COMMON OPTIONS (line 50)


-   **COMMON_OPTIONS_ALLOWED = "fhiqvVx-:"**

	List of default common short options.

-   **COMMON_OPTIONS_ALLOWED_MASK : REGEX mask that matches all common short options**

-   **COMMON_LONG_OPTIONS_ALLOWED="working-dir:,working-directory:,force,help,interactive,log:,logfile:,quiet,verbose,version,debug,dry-run,libvers,man,usage"**

	List of default common long options.

-   **COMMON_LONG_OPTIONS_ALLOWED_MASK : REGEX mask that matches all common long options**

-   **OPTIONS_ALLOWED | LONG_OPTIONS_ALLOWED : to be defined by the script**

-   **COMMON_SYNOPSIS COMMON_SYNOPSIS_ACTION COMMON_SYNOPSIS_ERROR COMMON_SYNOPSIS_MANPAGE COMMON_SYNOPSIS_ACTION_MANPAGE COMMON_SYNOPSIS_ERROR_MANPAGE (read-only)**

	Default values for synopsis strings (final fallback).

-   **OPTIONS_ADDITIONAL_INFOS_MANPAGE (read-only)**

	Information string about command line options how-to

-   **COMMON_OPTIONS_MANPAGE (read-only)**

	Information string about common script options

-   **COMMON_OPTIONS_USAGE (read-only)**

	Raw information string about common script options

-   **COMMON_OPTIONS_FULLINFO_MANPAGE (read-only)**

	Concatenation of COMMON_OPTIONS_MANPAGE & OPTIONS_ADDITIONAL_INFOS_MANPAGE

## LOREM IPSUM (line 68)


-   **LOREMIPSUM (844 chars.) , LOREMIPSUM_SHORT (446 chars.) , LOREMIPSUM_MULTILINE (861 chars. / 5 lines) (read-only)**

## LIBRARY SETUP (line 70)


-   **LIB_NAME LIB_VERSION LIB_DATE LIB_VCSVERSION LIB_VCSVERSION LIB_COPYRIGHT LIB_LICENSE_TYPE LIB_LICENSE_URL LIB_SOURCES_URL (read-only)**

	Library internal setup

## SYSTEM (line 73)


-   **get_system_info ()**


-   **get_machine_name ()**


-   **get_path ()**


	read current PATH values as human readable string

-   **add_path ( path )**


	add a path to global environment PATH

-   **get_script_path ( script = $0 )**


	get the full real path of a script directory (passed as argument) or from current executed script

-   **get_date ( timestamp = NOW )**


	cf. <http://www.admin-linux.fr/?p=1965>

-   **get_ip ()**


	this will load current IP address in USERIP & USERISP

## FILES (line 86)


-   **file_exists ( file_path )**


	test if a file, link or directory exists in the file-system

-   **is_file ( file_path )**


	test if a file exists in the file-system and is a 'true' file

-   **is_dir ( file_path )**


	test if a file exists in the file-system and is a directory

-   **is_link ( file_path )**


	test if a file exists in the file-system and is a symbolic link

-   **is_executable ( file_path )**


	test if a file or link exists in the file-system and has executable rights

-   **get_extension ( path = $0 )**


	retrieve a file extension

-   **get_filename ( path = $0 )**


	isolate a file name without dir & extension

-   **get_basename ( path = $0 )**


	isolate a file name

-   **get_dirname ( path = $0 )**


	isolate a file directory name

-   **get_absolute_path ( script = $0 )**


	get the real path of a script (passed as argument) or from current executed script

-   **/ realpath ( string )**


	alias of 'get_absolute_path'

-   **resolve ( path )**


	resolve a system path replacing '~' and '.'

## ARRAY (line 111)


-   **in_array ( item , $array[@] )**


	**@return:** 0 if item is found in array

-   **array_search ( item , $array[@] )**


	**@return:** the index of an array item, 0 based

-   **array_filter ( $array[@] )**


	**@return:** array with cleaned values

## STRING (line 118)


-   **string_length ( string )**


	**@return:** the number of characters in string

-   **/ strlen ( string )**


	alias of 'string_length'

-   **string_to_upper ( string )**


-   **/ strtoupper ( string )**


	alias of 'string_to_upper'

-   **string_to_lower ( string )**


-   **/ strtolower ( string )**


	alias of 'string_to_lower'

-   **upper_case_first ( string )**


-   **/ ucfirst ( string )**


	alias of 'upper_case_first'

-   **MAX_LINE_LENGTH = 80 : default max line length for word wrap (integer)**

-   **LINE_ENDING = n : default line ending character for word wrap**

-   **word_wrap ( text )**


-   **explode ( str , delim = ' ' )**


-   **implode ( array[@] , delim = ' ' )**


-   **explode_letters ( str )**


## BOOLEAN (line 138)


-   **onoff_bit ( bool )**


	echoes 'on' if bool=true, 'off' if it is false

## UTILS (line 141)


-   **is_numeric ( value )**


-   **is_numeric_by_variable_name ( variable_name )**


-   **is_array ( $array[*] )**


	this will (only for now) test if there 1 or more arguments passed
	and will therfore return '1' (false) for a single item array

	   echo "${tmpvar[*]}"

-   **is_array_by_variable_name ( variable_name )**


-   **is_boolean ( value )**


-   **is_boolean_by_variable_name ( variable_name )**


-   **is_string ( value )**


-   **is_string_by_variable_name ( variable_name )**


## VCS (line 153)


-   **VCSVERSION**

	Variable used as version marker like `branch@commit_sha`

-   **SCRIPT_VCS**

	VCS type of the script (only 'git' for now)

-   **get_version_string ( file_path = $0 , constant_name = VCSVERSION )**


	get the version string from a file_path

-   **get_version_sha ( get_version_string )**


	get last commit sha from a GIT version string

-   **get_version_branch ( get_version_string )**


	get the branch name from a GIT version string

-   **vcs_is_clone ( path = pwd , remote_url = null )**


-   **vcs_get_branch ( path = pwd )**


-   **vcs_get_commit ( path = pwd )**


-   **vcs_get_version ( path = pwd )**


-   **vcs_get_remote_version ( path = pwd , branch = HEAD )**


-   **vcs_make_clone ( repository_url , target_dir = LIB_SYSCACHEDIR )**


-   **vcs_update_clone ( target_dir )**


-   **vcs_change_branch ( target_dir , branch = 'master' )**


-   **CURRENT_GIT_CLONE_DIR**

	Environment variable to store current GIT clone directory

-   **git_is_clone ( path = pwd , remote_url = null )**


	check if a path, or `pwd`, is a git clone of a remote if 2nd argument is set

-   **git_get_branch ( path = pwd )**


-   **git_get_commit ( path = pwd )**


-   **git_get_version ( path = pwd )**


-   **git_get_remote_version ( path = pwd , branch = HEAD )**


	get the last GIT commit SHA from the remote in branch

-   **git_make_clone ( repository_url , target_dir = LIB_SYSCACHEDIR )**


	create a git clone of a distant repository in CURRENT_GIT_CLONE_DIR

	**@env:** clone directory is loaded in CURRENT_GIT_CLONE_DIR

-   **git_update_clone ( target_dir )**


	update a git clone

	**@param:** target_dir: name of the clone in LIB_SYSCACHEDIR or full path of concerned clone

-   **git_change_branch ( target_dir , branch = 'master' )**


	change a git clone tracking branch

	**@param:** target_dir: name of the clone in LIB_SYSCACHEDIR or full path of concerned clone

## COLORIZED CONTENTS (line 190)


-   **LIBCOLORS = ( default black red green yellow blue magenta cyan grey white lightred lightgreen lightyellow lightblue lightmagenta lightcyan lightgrey ) (read-only)**

	Terminal colors table

-   **LIBTEXTOPTIONS = ( normal bold small underline blink reverse hidden ) (read-only)**

	Terminal text options table

-   **get_text_format_tag ( code )**


	echoes the terminal tag code for color: " 033[CODEm"

	**@param:** code must be one of the library colors or text-options codes

-   **get_color_code ( name , background = false )**


	**@param:** name must be in LIBCOLORS

-   **get_color_tag ( name , background = false )**


	**@param:** name must be in LIBCOLORS

-   **get_text_option_code ( name )**


	**@param:** name must be in LIBTEXTOPTIONS

-   **get_text_option_tag ( name )**


	**@param:** name must be in LIBTEXTOPTIONS

-   **get_text_option_tag_close ( name )**


	**@param:** name must be in LIBTEXTOPTIONS

-   **colorize ( string , text_option , foreground , background )**


	echoes a colorized string ; all arguments are optional except `string`

	**@param:** text_option must be in LIBTEXTOPTIONS

	**@param:** foreground must be in LIBCOLORS

	**@param:** background must be in LIBCOLORS

-   **parse_color_tags ( "string with <bold>tags</bold>" )**


	parse in-text tags like:

	    ... <bold>my text</bold> ...     // "tag" in LIBTEXTOPTIONS

	    ... <red>my text</red> ...       // "tag" in LIBCOLORS

	    ... <bgred>my text</bgred> ...   // "tag" in LIBCOLORS, constructed as "bgTAG"

-   **strip_colors ( string )**


## TEMPORARY FILES (line 219)


-   **get_tempdir_path ( dirname = "LIB_TEMPDIR" )**


	creates a default temporary dir with fallback: first in current dir then in system '/tmp/'

	the real temporary directory path is loaded in the global `TEMPDIR`

	**@param:** dirname The name of the directory to create (default is `tmp/`)

-   **get_tempfile_path ( filename , dirname = "LIB_TEMPDIR" )**


	this will echoes a unique new temporary file path

	**@param:** filename The temporary filename to use

	**@param:** dirname The name of the directory to create (default is `tmp/`)

-   **create_tempdir ( dirname = "LIB_TEMPDIR" )**


	this will create a temporary directory in the working directory with full rights

	use this method to over-write an existing temporary directory

	**@param:** dirname The name of the directory to create (default is `tmp/`)

-   **clear_tempdir ( dirname = "LIB_TEMPDIR" )**


	this will deletes the temporary directory

	**@param:** dirname The name of the directory (default is `tmp/`)

-   **clear_tempfiles ( dirname = "LIB_TEMPDIR" )**


	this will deletes the temporary directory contents (not the directory itself)

	**@param:** dirname The name of the directory (default is `tmp/`)

## LOG FILES (line 238)


-   **get_log_filepath ()**


	creates a default placed log file with fallback: first in '/var/log' then in LIB_SYSHOMEDIR, finally in current dir

	the real log file path is loaded in the global `LOGFILEPATH

-   **log ( message , type='' )**


	this will add an entry in LOGFILEPATH

-   **read_log ()**


	this will read the LOGFILEPATH content

## CONFIGURATION FILES (line 246)


-   **get_global_configfile ( file_name )**


-   **get_user_configfile ( file_name )**


-   **read_config ( file_name )**


	read a default placed config file with fallback: first in 'etc/' then in '~/'

-   **read_configfile ( file_path )**


	read a config file

-   **write_configfile ( file_path , array_keys , array_values )**


	array params must be passed as "array[@]" (no dollar sign)

-   **set_configval ( file_path , key , value )**


-   **get_configval ( file_path , key )**


-   **build_configstring ( array_keys , array_values )**


	params must be passed as "array[@]" (no dollar sign)

## LIBRARY VARS (line 259)


-   **verbose_mode ( 1/0 )**


	This enables or disables the "verbose" mode.

	If it is enabled, the "quiet" mode is disabled.

	**@env:** VERBOSE

-   **quiet_mode ( 1/0 )**


	This enables or disables the "quiet" mode.

	If it is enabled, the "verbose" mode is disabled.

	**@env:** QUIET

-   **debug_mode ( 1/0 )**


	This enables or disables the "debug" mode.

	If it is enabled, the "verbose" mode is enabled too and the "quiet" mode is disabled.

	**@env:** DEBUG

-   **interactive_mode ( 1/0 )**


	This enables or disables the "interactive" mode.

	If it is enabled, the "forced" mode is disabled.

	**@env:** INTERACTIVE

-   **forcing_mode ( 1/0 )**


	This enables or disables the "forced" mode.

	If it is enabled, the "interactive" mode is disabled.

	**@env:** INTERACTIVE

-   **dryrun_mode ( 1/0 )**


	This enables or disables the "dry-run" mode.

	If it is enabled, the "interactive" and "forced" modes are disabled.

	**@env:** DRYRUN

-   **set_working_directory ( path )**


	handles the '-d' option for instance

	throws an error if 'path' does not exist

-   **set_log_filename ( path )**


	handles the '-l' option for instance

-   **ECHOCMD (read-only: 'builtin' or 'gnu')**

	Test if 'echo' is shell builtin or program

-   **_echo ( string )**


	echoes the string with the true 'echo -e' command

	use this for colorization

-   **_necho ( string )**


	echoes the string with the true 'echo -en' command

	use this for colorization and no new line

-   **prompt ( string , default = y , options = Y/n )**


	prompt user a string proposing different response options and selecting a default one

	final user fill is loaded in USERRESPONSE

-   **selector_prompt ( list[@] , string , list_string , default = 1 )**


	prompt user a string proposing an indexed list of answers for selection
	and returns a valid result (user is re-prompted while the answer seems not correct)

	NOTE - the 'list' MUST be passed like `list[@]` (no quotes and dollar sign)

	final user choice is loaded in USERRESPONSE

-   **verbose_echo ( string )**


	Echoes the string(s) in "verbose" mode.

-   **/ verecho ( string )**


	alias of 'verbose_echo'

-   **quiet_echo ( string )**


	Echoes the string(s) in not-"quiet" mode.

-   **/ quietecho ( string )**


	alias of 'quiet_echo'

-   **debug_echo ( string )**


	Echoes the string(s) in "debug" mode.

-   **/ debecho ( string )**


	alias of 'debug_echo'

-   **evaluate ( command )**


	evaluates the command catching events:

	- stdout is loaded in global `$CMD_OUT`

	- stderr is loaded in global `$CMD_ERR`

	- final status is loaded in global `$CMD_STATUS`

	**@env:** CMD_OUT CMD_ERR CMD_STATUS : loaded with evaluated command's STDOUT, STDERR and STATUS

	**@error:** will end with any caught error (exit status !=0)

-   **debug_evaluate ( command )**


	evaluates the command if "dryrun" is "off", just write it on screen otherwise

-   **/ debevaluate ( command )**


	alias of 'debug_evaluate'

-   **/ debeval ( command )**


	alias of 'debug_evaluate'

-   **interactive_evaluate ( command , debug_exec = true )**


	evaluates the command after user confirmation if "interactive" is "on"

-   **/ ievaluate ( command )**


	alias of 'interactive_evaluate'

-   **/ ieval ( command )**


	alias of 'interactive_evaluate'

-   **execute ( command )**


	executes the command with outputs and status handling

-   **debug_execute ( command )**


	execute the command if "dryrun" is "off", just write it on screen otherwise

-   **/ debug_exec ( command )**


	alias of 'debug_execute'

-   **/ debexec ( command )**


	alias of 'debug_execute'

-   **interactive_execute ( command , debug_exec = true )**


	executes the command after user confirmation if "interactive" is "on"

-   **/ interactive_exec ( command , debug_exec = true )**


	alias of 'interactive_execute'

-   **/ iexec ( command , debug_exec = true )**


	alias of 'interactive_execute'

## MESSAGES / ERRORS (line 351)


-   **info ( string, bold = true )**


	writes the string on screen and return

-   **warning ( string , funcname = FUNCNAME[1] , line = BASH_LINENO[1] , tab='    ' )**


	writes the error string on screen and return

-   **error ( string , status = 90 , funcname = FUNCNAME[1] , line = BASH_LINENO[1] , tab='   ' )**


	writes the error string on screen and then exit with an error status

	**@error:** default status is E_ERROR (90)

-   **get_synopsis_string ( short_opts=OPTIONS_ALLOWED , long_opts=LONG_OPTIONS_ALLOWED )**


	builds a synopsis string using script's declared available options

-   **simple_synopsis ()**


	writes a synopsis string using script's declared available options

-   **simple_usage ( synopsis = SYNOPSIS_ERROR )**


	writes a synopsis usage info

-   **simple_error ( string , status = 90 , synopsis = SYNOPSIS_ERROR , funcname = FUNCNAME[1] , line = BASH_LINENO[1] )**


	writes an error string as a simple message with a synopsis usage info

	**@error:** default status is E_ERROR (90)

-   **simple_error_multi ( array[@] , status = 90 , synopsis = SYNOPSIS_ERROR , funcname = FUNCNAME[1] , line = BASH_LINENO[1] )**


	writes multiple errors strings as a simple message with a synopsis usage info

	**@error:** default status is E_ERROR (90)

-   **dev_error ( string , status = 90 , filename = BASH_SOURCE[2] , funcname = FUNCNAME[2] , line = BASH_LINENO[2] )**


	print a formated error string with dev info using the 'caller' stack trace and exit

	print a full back trace it `VERBOSE=true`

-   **get_stack_trace ( first_item = 0 )**


	get a formated stack trace

-   **gnu_error_string ( string , filename = BASH_SOURCE[2] , funcname = FUNCNAME[2] , line = BASH_LINENO[2] )**


	must echoes something like 'sourcefile:lineno: message'

-   **no_option_error ()**


	no script option error

	**@error:** exits with status E_OPTS (81)

-   **no_option_simple_error ()**


	no script option simple error

	**@error:** exits with status E_OPTS (81)

-   **unknown_option_error ( option )**


	invalid script option error

	**@error:** exits with status E_OPTS (81)

-   **unknown_option_simple_error ( option )**


	invalid script option simple error

	**@error:** exits with status E_OPTS (81)

-   **command_error ( cmd )**


	command not found error

	**@error:** exits with status E_CMD (82)

-   **command_simple_error ( cmd )**


	command not found simple error

	**@error:** exits with status E_CMD (82)

-   **path_error ( path )**


	path not found error

	**@error:** exits with status E_PATH (83)

-   **path_simple_error ( path )**


	path not found simple error

	**@error:** exits with status E_PATH (83)

## SCRIPT OPTIONS / ARGUMENTS (line 402)


-   **ORIGINAL_SCRIPT_OPTS="$@" (read-only)**

	Original list of raw command line arguments

-   **SCRIPT_PARAMS=''**

	String of re-arranged parameters (options & arguments)

-   **SCRIPT_PIPED_INPUT=''**

	String of any piped content from previous command

-   **SCRIPT_OPTS=()**

	Array of options with arguments

-   **SCRIPT_ARGS=()**

	Array of script's arguments

-   **SCRIPT_PROGRAMS=()**

	Array of program's options

-   **SCRIPT_OPTS_ERRS=()**

	Array of options errors

-   **ARGIND**

	Integer of current argument index

-   **ARGUMENT**

	Current argument string (see `ARGIND`)

	Options errors messages

-   **read_from_pipe ( file=/dev/stdin )**


-   **get_short_options_array ( short_opts=OPTIONS_ALLOWED )**


-   **get_short_options_string ( delimiter = '|' , short_opts=OPTIONS_ALLOWED )**


-   **get_option_declaration ( option_name , short_opts=OPTIONS_ALLOWED )**


-   **get_option_argument ( "$x" )**


	echoes the argument of an option

-   **/ get_option_arg ( "$x" )**


	alias of 'get_option_argument'

-   **get_long_options_array ( long_opts=LONG_OPTIONS_ALLOWED )**


-   **get_long_options_string ( delimiter = '|' , long_opts=LONG_OPTIONS_ALLOWED )**


-   **get_long_option_declaration ( option_name , long_opts=LONG_OPTIONS_ALLOWED )**


-   **get_long_option_name ( "$x" )**


	echoes the name of a long option

-   **/ get_long_option ( "$x" )**


	alias of 'get_long_option_name()'

-   **get_long_option_argument ( "$x" )**


	echoes the argument of a long option

-   **/ get_long_option_arg ( "$x" )**


	alias of 'get_long_option_argument'

-   **LONGOPTNAME=''**

	The name of current long option treated

-   **LONGOPTARG=''**

	The argument set for current long option

-   **parse_long_option ( $OPTARG , ${!OPTIND} )**


	This will parse and retrieve the name and argument of current long option.

-   **init_arguments ()**


	init the script arguments treatment putting `ARGIND` on `1` if arguments exist

-   **getargs ( VAR_NAME )**


	method to loop over command line's arguments just like `getopts` does for options

	this will load current argument's value in `VAR_NAME` and increment `ARGIND` at each turn

-   **get_next_argument ()**


	get next script argument according to current `ARGIND`

	load it in `ARGUMENT` and let `ARGIND` incremented

-   **get_last_argument ()**


	echoes the last script argument

-   **rearrange_script_options_new ( "$0" , "$@"  )**


-   **rearrange_script_options ( "$@" )**


	this will separate script options from script arguments (emulation of GNU "getopt")

	options are loaded in $SCRIPT_OPTS with their arguments

	arguments are loaded in $SCRIPT_ARGS

-   **parse_common_options_strict ( "$@" = SCRIPT_OPTS )**


	parse common script options as described in $COMMON_OPTIONS_INFO throwing an error for unknown options

	this will stop options treatment at '--'

-   **parse_common_options ( "$@" = SCRIPT_OPTS )**


	parse common script options as described in $COMMON_OPTIONS_INFO

	this will stop options treatment at '--'

## SCRIPT INFO (line 468)


-   **get_script_version_string ( quiet = false )**


-   **script_title ( lib = false )**


	this function must echo an information about script NAME and VERSION

	setting `$lib` on true will add the library infos

-   **script_short_title ()**


	this function must echo an information about script NAME and VERSION

-   **script_usage ()**


	this function must echo the simple usage

-   **script_long_usage ( synopsis = SYNOPSIS_ERROR , options_string = COMMON_OPTIONS_USAGE )**


	writes a long synopsis usage info

-   **script_help ( lib_info = true )**


	this function must echo the help information USAGE (with option "-h")

-   **script_manpage ( cmd = $0 , section = 3 )**


	will open the manpage of $0 if found in system manpages or if `$0.man` exists

	else will trigger 'script_help' method

-   **script_short_version ( quiet = false )**


-   **script_version ( quiet = false )**


## DOCBUILDER (line 486)


	Documentation builder rules, tags and masks

-   **DOCBUILDER_MASKS = ()**

-   **DOCBUILDER_MARKER = '##@!@##'**

-   **DOCBUILDER_RULES = ( ... )**

-   **build_documentation ( type = TERMINAL , output = null , source = BASH_SOURCE[0] )**


-   **generate_documentation ( filepath = BASH_SOURCE[0] , output = null )**


## LIBRARY INFO (line 493)


-   **get_library_version_string ( path = $0 )**


	extract the GIT version string from a file matching line 'LIB_VCSVERSION=...'

-   **library_info ()**


-   **library_path ()**


-   **library_help ()**


-   **library_usage ()**


-   **library_short_version ( quiet = false )**


	this function must echo an information about library name & version

-   **library_version ( quiet = false )**


	this function must echo an FULL information about library name & version (GNU like)

-   **library_debug ( "$*" )**


	see all common options flags values & some debug infos

-   **/ libdebug ( "$*" )**


	alias of library_debug

## LIBRARY INTERNALS (line 508)


-   **LIBRARY_REALPATH LIBRARY_DIR LIBRARY_BASEDIR LIBRARY_SOURCEFILE**

-   **make_library_homedir ()**


	make dir '$HOME/.piwi-bash-library' if it doesn't exist

-   **make_library_cachedir ()**


	make dir '$HOME/.piwi-bash-library/cache' if it doesn't exist

-   **clean_library_cachedir ()**


	clean dir '$HOME/.piwi-bash-library/cache' if it exists

## INSTALLATION WIZARD (line 516)


-   **INSTALLATION_VARS = ( SCRIPT_VCS VCSVERSION SCRIPT_REPOSITORY_URL SCRIPT_FILES SCRIPT_FILES_BIN SCRIPT_FILES_MAN SCRIPT_FILES_CONF ) (read-only)**

-   **SCRIPT_REPOSITORY_URL = url of a distant repository**

-   **SCRIPT_FILES = array of installable files**

-   **SCRIPT_FILES_BIN = array of installable binary files**

-   **SCRIPT_FILES_MAN = array of manpages files**

-   **SCRIPT_FILES_CONF = array of configuration files**

	instwiz_get_real_version ( path = LIBINST_CLONE )

	get the real vcs_get_version from a repo

	instwiz_remoteversion ( path = LIBINST_CLONE , branch = HEAD )

	get the last commit SHA from the remote in branch

	instwiz_prepare_install_cmd ()

	instwiz_prepare_uninstall_cmd ()

-   **script_installation_target ( target_dir = $HOME/bin )**


-   **script_installation_source ( clone_repo = SCRIPT_REPOSITORY_URL , clone_dir = LIB_SYSCACHEDIR )**


-   **script_install ( path = $HOME/bin/ )**


-   **script_check ( file_name , original = LIBINST_CLONE , target = LIBINST_TARGET )**


	**@param:** file_name: the file to check and compare on both sides

-   **script_update ( path = $HOME/bin/ )**


-   **script_uninstall ( path = $HOME/bin/ )**


## COMPATIBILITY (line 539)


----

[*Doc generated at 02-1-2015 01:13:22 from path 'bin/piwi-bash-library.bash'*]
