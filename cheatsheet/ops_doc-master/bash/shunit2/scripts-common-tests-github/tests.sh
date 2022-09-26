#!/bin/bash
##
## Author: Bertrand Benoit <mailto:contact@bertrand-benoit.net>
## Description: Tests all features provided by utilities script.
## Version: 1.0

#DEBUG_UTILITIES=1
export CATEGORY="tests:general"
export DISABLE_ERROR_TRAP=1
export ERROR_MESSAGE_EXITS_SCRIPT=0
export LOG_CONSOLE_OFF=1

# Ensures utilities path has been defined, and sources it.
[ -z "${SCRIPTS_COMMON_PATH:-}" ] && echo "SCRIPTS_COMMON_PATH environment variable must be defined." >&2 && exit 1
# shellcheck disable=1090
. "$SCRIPTS_COMMON_PATH"

## Defines some constants.
currentDir=$( dirname "$( command -v "$0" )" )
declare -r miscDir="$currentDir/misc"
declare -r daemonSample="$miscDir/daemonSample"

# usage: enteringTests <test category>
function enteringTests() {
  local _testCategory="$1"
  CATEGORY="tests:$_testCategory"

  info "$_testCategory feature tests - BEGIN"
}

# usage: exitingTests <test category>
function exitingTests() {
  local _testCategory="$1"
  CATEGORY="tests:general"

  info "$_testCategory feature tests - END"
}

## Define Tests functions.
# Logger feature Tests.
testLoggerFeature() {
  enteringTests "logger"

  info "Simple message tests (should not have prefix)" || fail "Logger INFO level"
  writeMessage "Info message test" || fail "Logger NORMAL level"
  warning "Warning message test" || fail "Logger WARNING level"
  errorMessage "Error message test" -1  || fail "Logger ERROR level" # -1 to avoid automatic exit of the script

  exitingTests "logger"
}

# Robustness Tests.
testLoggerRobustness() {
  local _logLevel _message _newLine _exitStatus

  enteringTests "robustness"

  _logLevel="$LOG_LEVEL_MESSAGE"
  _message="Simple message"
  _newLine="1"
  _exitStatus="-1"

  # doWriteMessage should NOT be called directly, but user can still do it, ensures robustness on parameters control.
  # Log level
 _doWriteMessage "Broken Log level ..." "$_message" "$_newLine" "$_exitStatus" || fail "Broken Log level not detected"

  # Message
 _doWriteMessage "$_logLevel" "Message on \
                                several \
                                lines" "$_newLine" "$_exitStatus" || fail "Logger message on several lines, badly managed"

 _doWriteMessage "$_logLevel" "Message on \nseveral \nlines" "$_newLine" "$_exitStatus" || fail "Logger message on several lines, badly managed"
  # New line.
 _doWriteMessage "$_logLevel" "$_message" "Bad value" "$_exitStatus" || fail "Logger Bad value (new line), badly managed"

  # Exit status.
 _doWriteMessage "$_logLevel" "$_message" "$_newLine" "Bad value" || fail "Logger Bad value (exit status), badly managed"

  exitingTests "robustness"
}

# Environment check feature Tests.
testEnvironmentCheckFeature() {
  enteringTests "envCheck"

  assertFalse "Checking if user is root" isRootUser
  assertTrue "Checking if 'GNU version' of which tool is installed" checkGNUWhich
  assertTrue "Checking environment" checkEnvironment
  assertTrue "Checking LSB" checkLSB

  LANG=en_GB checkLocale && fail "Checking Locale with no utf-8 LANG"
  LANG=zz_ZZ.UTF-8 checkLocale && fail "Checking Locale with not installed/existing utf-8 LANG"
  LANG=en_GB.UTF-8 checkLocale || fail "Checking Locale with a good LANG defined to en_GB.UTF-8"
  LANG=en_GB.utf8 checkLocale || fail "Checking Locale with a good LANG defined to en_GB.utf8"

  exitingTests "envCheck"
}

# Conditional Tests.
testConditionalBehaviour() {
  enteringTests "conditional"

  # Script should NOT break because of the pipe status ...
  # shellcheck disable=2050
  [ 0 -gt 1 ] || info "fake test ..."

  exitingTests "conditional"
}

# Version feature Tests.
testVersionFeature() {
  local _fileWithVersion _version _fakeVersion
  enteringTests "version"

  _fileWithVersion="$currentDir/../README.md"
  _version=$( getVersion "$_fileWithVersion" )
  _fakeVersion="999.999.999"

  info "scripts-common Utilities version: $_version"
  info "scripts-common Utilities detailed version: $( getDetailedVersion "$_version" "$currentDir/.." )"

  getDetailedVersion "$_version" "$currentDir/NotExistingDirectory" && fail "Checking getDetailedVersion on NOT existing directory"

  isVersionGreater "$_version" "$_fakeVersion" && fail "Checking if $_version is greater than $_fakeVersion"
  ! isVersionGreater "$_fakeVersion" "$_version" && fail "Checking if $_fakeVersion is greater than $_version"

  exitingTests "version"
}

# Time feature Tests.
testTimeFeature() {
  enteringTests "time"

  initializeStartTime
  sleep 1
  info "Uptime: $( getUptime )" || fail "Time feature"

  exitingTests "time"
}

testCheckPathFeature() {
  local _checkPathRootDir="$DEFAULT_TMP_DIR/checkPathRootDir"
  local _dataFileName="myFile.data"
  local _binFileName="myFile.bin"
  local _subPathDir="myDir"
  local _homeRelativePath="something/not/existing"
  local _pathsToFormatBefore _pathsToFormatAfter

  enteringTests "checkPath"

  # To avoid error when configuration key is not found, switch on this mode.
  MODE_CHECK_CONFIG=1

  # Limit tests, on not existing files.
  isEmptyDirectory "$_checkPathRootDir" && fail "Checking NOT existing directory, is empty (should answer NO)"

  updateStructure "$_checkPathRootDir" || fail "Update directories structure"

  checkDataFile "$_checkPathRootDir/$_dataFileName" && fail "Checking NOT existing Data file"

  checkBin "$_checkPathRootDir/$_binFileName" && fail "Checking NOT existing Binary file"

  checkPath "$_checkPathRootDir/$_subPathDir" && fail "Checking NOT existing Path"

  # Normal situation.
  touch "$_checkPathRootDir/$_dataFileName" "$_checkPathRootDir/$_binFileName" || fail "File creation"
  chmod +x "$_checkPathRootDir/$_binFileName" || fail "File permission update"
  updateStructure "$_checkPathRootDir/$_subPathDir" || fail "Update directories structure 2"

  isEmptyDirectory "$_checkPathRootDir/$_subPathDir" || fail "Checking existing directory is empty"

  checkDataFile "$_checkPathRootDir/$_dataFileName" || fail "Checking existing Data file"

  checkBin "$_checkPathRootDir/$_binFileName" || fail "Checking existing Binary file"

  checkPath "$_checkPathRootDir/$_subPathDir" || fail "Checking existing Path"

  # Absolute/Relative path and completePath.
  isAbsolutePath "$_checkPathRootDir" || fail "Checking isAbsolutePath function on absolute path"
  isAbsolutePath "$_subPathDir" && fail "Checking isAbsolutePath function on relative path"

  isRelativePath "$_checkPathRootDir" && fail "Checking isRelativePath function on absolute path"
  isRelativePath "$_subPathDir" || fail "Checking isRelativePath function on relative path"

  # Absolute path stays unchanged.
  assertEquals "$( buildCompletePath "$_checkPathRootDir" )" "$_checkPathRootDir" || fail "Checking buildCompletePath function on absolute path"

  # Relative path stays unchanged, if no prepend arguments is specified.
  assertEquals "$( buildCompletePath "$_subPathDir" )" "$_subPathDir" || fail "Checking buildCompletePath function on relative path, should stay unchanged"
  assertEquals "$( buildCompletePath "$_subPathDir" "$_checkPathRootDir" )" "$_subPathDir" || fail "Checking buildCompletePath function on relative path, should stay unchanged with not prepend option"

  # Relative path must be fully completed, with all prepend arguments.
  assertEquals "$( buildCompletePath "$_subPathDir" "$_checkPathRootDir" 1 )" "$_checkPathRootDir/$_subPathDir" || fail "Checking buildCompletePath function on relative path with prepend option"

  # Special situation: HOME subsitution.
  # "Tilde does not expand in quotes" => it is EXACTLY what we want here because it is the role of buildCompletePath function.
  # shellcheck disable=2088
  assertEquals "$( buildCompletePath "~/$_homeRelativePath" )" "$HOME/$_homeRelativePath" || fail "Checking buildCompletePath function, for ~ substitution with HOME environment variable"

  # Very important to switch off this mode to keep on testing others features.
  export MODE_CHECK_CONFIG=0

  # checkAndFormatPath Tests.
  # N.B.: at end, use a wildcard instead of the ending 'ir' part.
  _pathsToFormatBefore="$_subPathDir:~/$_homeRelativePath:${_subPathDir/ir/}*"
  _pathsToFormatAfter="$_checkPathRootDir/$_subPathDir:$HOME/$_homeRelativePath:$_checkPathRootDir/$_subPathDir"
  assertEquals "$( checkAndFormatPath "$_pathsToFormatBefore" "$_checkPathRootDir" )" "$_pathsToFormatAfter" || fail "Checking checkAndFormatPath function"

  # Very important to switch off this mode to keep on testing others features.
  export MODE_CHECK_CONFIG=0

  exitingTests "checkPath"
}

# Configuration file feature Tests.
testConfigurationFileFeature() {
  local _configKey="my.config.key"
  local _configKey2="another.config.key"
  local _configValue="my Value"
  local _configValue2="my second Value"
  local _configFile="$DEFAULT_TMP_DIR/localConfigurationFile.conf"

  enteringTests "config"

  info "A configuration key '$CONFIG_NOT_FOUND' should happen."

  # To avoid error when configuration key is not found, switch on this mode.
  export MODE_CHECK_CONFIG=1

  # No configuration file defined, it should not be found.
  checkAndSetConfig "$_configKey" "$CONFIG_TYPE_OPTION"
  assertEquals "$LAST_READ_CONFIG" "$CONFIG_NOT_FOUND" || fail "Configuration not found, badly detected"

  # TODO: check all other kind of $CONFIG_TYPE_XX

  # Tests config keys listing, without any configuration file at all.
  [ -z "$( listConfigKeys )" ] || fail "Configuration key listing, with no pattern and no configuration file at all, should work"

  # Tests config <key, value> listing, without any configuration file at all.
  loadConfigKeyValueList
  [ -z "${!LAST_READ_CONFIG_KEY_VALUE_LIST[*]}" ] || fail "Configuration <key, value> listing, with no pattern and no configuration file at all, should work"

  # Create a configuration file (including comment, and extra spaces which should be ignored).
  info "Creating the temporary configuration file '$_configFile', and configuration key should then be found."
  export CONFIG_FILE="$_configFile"
cat > "$_configFile" <<EOF
#$_configKey="WRONG$_configValue"
    $_configKey="$_configValue"
#$_configKey="WRONG$_configValue"
$_configKey2="$_configValue2"
#mustNotBeInList$_configKey="$_configValue"
EOF

  # Tests config key listing.
  declare -a expectedCompleteConfigKeyList=( "$_configKey" "$_configKey2" ) # N.B.: order is the one appearing in the file
  IFS= read -r -a readCompleteConfigKeyList <<< "$( listConfigKeys )"
  assertEquals "${expectedCompleteConfigKeyList[*]}" "${readCompleteConfigKeyList[*]}" || fail "Configuration key listing, without pattern, should work"

  assertEquals "$_configKey2" "$( listConfigKeys ".*${_configKey2:1:3}.*" )" || fail "Configuration key listing, with existing pattern, should work"

  [ -z "$( listConfigKeys "doesNotExist" )" ] || fail "Configuration key listing, with NOT existing pattern, should not return anything"

  # Tests config <key, value> listing, with user configuration file, without pattern.
  declare -A expectedCompleteConfigKeyValueList=( ["$_configKey"]="$_configValue" ["$_configKey2"]="$_configValue2" ) # N.B.: order is the one appearing in the file
  loadConfigKeyValueList
  #  Checks count of elements.
  assertEquals "${#expectedCompleteConfigKeyValueList[@]}" "${#LAST_READ_CONFIG_KEY_VALUE_LIST[@]}" || fail "Configuration <key, value> listing, with no pattern, count of element is not GOOD"

  #  Checks each existing element.
  for configKey in "${!expectedCompleteConfigKeyValueList[@]}"; do
    assertEquals "${expectedCompleteConfigKeyValueList[$configKey]}" "${LAST_READ_CONFIG_KEY_VALUE_LIST[$configKey]:-}" || fail "Configuration <key, value> listing, with no pattern, element not existing or different value"
  done

  # Tests config <key, value> listing, with user configuration file, with search pattern.
  declare -A expectedCompleteConfigKeyValueList=( ["$_configKey2"]="$_configValue2" ) # N.B.: order is the one appearing in the file
  loadConfigKeyValueList ".*${_configKey2:1:3}.*"
  #  Checks count of elements.
  assertEquals "${#expectedCompleteConfigKeyValueList[@]}" "${#LAST_READ_CONFIG_KEY_VALUE_LIST[@]}" || fail "Configuration <key, value> listing, with search pattern, count of element is not GOOD"

  #  Checks each existing element.
  for configKey in "${!expectedCompleteConfigKeyValueList[@]}"; do
    assertEquals "${expectedCompleteConfigKeyValueList[$configKey]}" "${LAST_READ_CONFIG_KEY_VALUE_LIST[$configKey]:-}" || fail "Configuration <key, value> listing, with search pattern, element not existing or different value"
  done

  # Tests config <key, value> listing, with user configuration file, with search and remove pattern.
  declare -A expectedCompleteConfigKeyValueList=( ["${_configKey2:8}"]="$_configValue2" ) # N.B.: order is the one appearing in the file
  loadConfigKeyValueList ".*${_configKey2:1:3}.*" "${_configKey2:0:8}"
  #  Checks count of elements.
  assertEquals "${#expectedCompleteConfigKeyValueList[@]}" "${#LAST_READ_CONFIG_KEY_VALUE_LIST[@]}" || fail "Configuration <key, value> listing, with search and key remove patterns, count of element is not GOOD"

  #  Checks each existing element.
  for configKey in "${!expectedCompleteConfigKeyValueList[@]}"; do
    assertEquals "${expectedCompleteConfigKeyValueList[$configKey]}" "${LAST_READ_CONFIG_KEY_VALUE_LIST[$configKey]:-}" || fail "Configuration <key, value> listing, with search and key remove patterns, element not existing or different value"
  done

  # Tests checkAndSetConfig.
  checkAndSetConfig "$_configKey" "$CONFIG_TYPE_OPTION"
  info "$LAST_READ_CONFIG"
  assertEquals "$_configValue" "$LAST_READ_CONFIG" || fail "Configuration should have been found, and have good value"


  # Very important to switch off this mode to keep on testing others features.
  export MODE_CHECK_CONFIG=0

  exitingTests "config"
}

# Lines feature Tests.
testLinesFeature() {
  local _fileToCheck _fromLine _toLine _result
  _fileToCheck="$0"
  _fromLine=4
  _toLine=8

  enteringTests "lines"

  # TODO: creates a dedicated test file, and ensures the result ... + test all limit cases
  _result=$( getLastLinesFromN "$_fileToCheck" "$_fromLine" ) || fail "Getting lines of file '$_fileToCheck', from line '$_fromLine'"

  _result=$( getLinesFromNToP "$_fileToCheck" "$_fromLine" "$_toLine" ) || fail "Getting lines of file '$_fileToCheck', from line '$_fromLine', to line '$_toLine' (extract lines)"
  [ "$( echo "$_result" |wc -l )" -ne $((_toLine - _fromLine + 1)) ] && fail "Getting lines of file '$_fileToCheck', from line '$_fromLine', to line '$_toLine' (count of lines)"

  exitingTests "lines"
}

# PID file feature Tests, without the Daemon layer which is tested elsewhere.
testPidFileFeature() {
  local _pidFile
  enteringTests "pidFiles"

  _pidFile="$DEFAULT_PID_DIR/testPidFileFeature.pid"

  # Limit tests, on not existing PID file.
  rm -f "$_pidFile"
  deletePIDFile "$_pidFile" || fail "deletePIDFile on not existing file, must NOT fail"

  getPIDFromFile "$_pidFile" && fail "getPIDFromFile with a not existing file, must produce an ERROR"

  getProcessNameFromFile "$_pidFile" && fail "getProcessNameFromFile with a not existing file, must produce an ERROR"

  isRunningProcess "$_pidFile" "$0" && fail "isRunningProcess with a not existing file, must produce an ERROR"

  # Normal situation.
  writePIDFile "$_pidFile" "$0" || fail "Create properly a PID file for this process"
  writePIDFile "$_pidFile" "$0" && fail "Trying to write in the existing PID file, must produce an ERROR"

  isRunningProcess "$_pidFile" "$0" || fail "Check if system consider this process as still running"

  deletePIDFile "$_pidFile" || fail "Delete the PID file"

  # TODO: test checkAllProcessFromPIDFiles

  exitingTests "pidFiles"
}

# Tests Deaemon feature.
testDaemonFeature() {
  local _pidFile _daemonDirPath _daemonName _daemonCompletePath

  enteringTests "daemon"

  export PID_DIR="$DEFAULT_PID_DIR/testDaemonFeature/_pids"
  _daemonDirPath="$DEFAULT_TMP_DIR/testDaemonFeature"
  _daemonName="myDaemonTest.sh"
  _daemonCompletePath="$_daemonDirPath/$_daemonName"

  # Environment creation.
  updateStructure "$_daemonDirPath" || fail "Update structure"
  rm -f "$_daemonCompletePath" || fail "Clean Daemon file"
  cp "$daemonSample" "$_daemonCompletePath" || fail "Create daemon file"
  chmod +x "$_daemonCompletePath" || fail "Change daemon file permission"

  "$_daemonCompletePath" -T || fail "Checking the status of the Daemon ... expected result: NOT running"

  "$_daemonCompletePath" -K || fail "Requesting to stop the Daemon ... (warning can occur because of the process killing) expected result: NOT running"

  "$_daemonCompletePath" -S || fail "Starting the Daemon"
  sleep 2

  "$_daemonCompletePath" -T || fail "Checking the status of the Daemon ... expected result: running"

  "$_daemonCompletePath" -K || fail "Requesting to stop the Daemon ... expected result: NOT running"

  "$_daemonCompletePath" -T || fail "Checking the status of the Daemon ... expected result: NOT running"

  unset PID_DIR
  exitingTests "daemon"
}

testPatternMatchingFeature() {
    local _pattern1="[My ]*f?irst[ pattern]*" _pattern2="[ \t][0-9][0-9]*[ \t]" _pattern3="^NoThing[ \t]*Void$"
    declare -a patterns=( "$_pattern1" "$_pattern2" "$_pattern3")

    enteringTests "patternMatching"

    # matchesOneOf
    matchesOneOf "ShouldNotMatchAnything" "${patterns[@]}" && fail "Pattern matching should NOT have matched"
    matchesOneOf "irst" "${patterns[@]}" || fail "Pattern matching should have matched with pattern 1"
    matchesOneOf "Yeah this 56 tests should be OK" "${patterns[@]}" || fail "Pattern matching should have matched with pattern 2"
    matchesOneOf "NoThingVoid" "${patterns[@]}" || fail "Pattern matching should have matched with pattern 3"
    matchesOneOf "Thing" "${patterns[@]}" && fail "Pattern matching should NOT have matched"

    # isNumber && isCompoundedNumber
    isNumber "0" || fail "isNumber, bad answer on '0'"
    isNumber "054" || fail "isNumber, bad answer on '054'"
    isNumber "999999" || fail "isNumber, bad answer on '999999'"
    isNumber "5-9" && fail "isNumber, bad answer on '5-9'"

    isCompoundedNumber "0" || fail "isCompoundedNumber, bad answer on '0'"
    isCompoundedNumber "054" || fail "isCompoundedNumber, bad answer '054'"
    isCompoundedNumber "999999" || fail "isCompoundedNumber, bad answer on '999999'"
    isCompoundedNumber "5-9" || fail "isCompoundedNumber, bad answer on '5-9'"
    isCompoundedNumber "30-098" || fail "isCompoundedNumber, bad answer on '30-098'"

    # removeAllSpecifiedPartsFromString
    local _string="NothingToChange"
    local _result=$( removeAllSpecifiedPartsFromString "$_string" "$_pattern1|$_pattern2|$_pattern3" )
    assertEquals "$_result" "$_string" || fail "removeAllSpecifiedPartsFromString failure on '$_string'"

    local _string="MyFirstString"
    local _result=$( removeAllSpecifiedPartsFromString "$_string" "$_pattern1|$_pattern2|$_pattern3" )
    assertEquals "$_result" "MyFString" || fail "removeAllSpecifiedPartsFromString failure on '$_string' with case sensitive"
    local _result=$( removeAllSpecifiedPartsFromString "$_string" "$_pattern1|$_pattern2|$_pattern3" "1")
    assertEquals "$_result" "String" || fail "removeAllSpecifiedPartsFromString failure on '$_string' with case insensitive"

    local _string="MyFirstString 999999 "
    local _result=$( removeAllSpecifiedPartsFromString "$_string" "$_pattern1|$_pattern2|$_pattern3" "1" )
    assertEquals "$_result" "String" || fail "removeAllSpecifiedPartsFromString failure on '$_string'"

    # extractNumberSequence
    assertEquals "$( extractNumberSequence "LotsOfUselessThings_2_AndSomeMore.myExtension")" "2" || fail "extractNumberSequence failure on '2'"
    assertEquals "$( extractNumberSequence "LotsOfUselessThings.3.AndSomeMore.myExtension")" "3" || fail "extractNumberSequence failure on '3'"
    assertEquals "$( extractNumberSequence "LotsOfUselessThings.E5.AndSomeMore.myExtension")" "5" || fail "extractNumberSequence failure on '5'"
    assertEquals "$( extractNumberSequence "LotsOfUselessThings.7-9.AndSomeMore.myExtension")" "7-9" || fail "extractNumberSequence failure on '7-9'"
    assertEquals "$( extractNumberSequence "LotsOfUselessThings.11 à 13.AndSomeMore.myExtension")" "11-13" || fail "extractNumberSequence failure on '11-13'"
    assertEquals "$( extractNumberSequence "LotsOfUselessThings.17 & 19.AndSomeMore.myExtension")" "17-19" || fail "extractNumberSequence failure on '17-19'"
    assertEquals "$( extractNumberSequence "LotsOfUselessThings29-29AndSomeMore.myExtension")" "29-29" || fail "extractNumberSequence failure on '29-29'"

    exitingTests "patternMatching"
}

# Triggers shUnit 2.
# shellcheck disable=1090
. "$currentDir/shunit2/shunit2"
