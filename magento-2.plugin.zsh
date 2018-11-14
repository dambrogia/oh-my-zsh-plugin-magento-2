# Base constants
SCRIPT_DIR=${0:a:h}
MAGE_ROOT_FILE=${SCRIPT_DIR}/mage_root.txt
MAGE_AUTOCOMPLETE_FILE=${SCRIPT_DIR}/mage_autocomplete.txt

function m2:help() {
    HELP_MSG="
Description:
    Magento 2 zsh autocomplete plugin

Author:
    Dominic Dambrogia <domdambrogia+mage-2-plugin@gmail.com>

Functions:
    m2                      Runs <mage_root>/bin/magento
    m2:help                 View this help message
    m2:set_root             Set root project directory for Magento
    m2:get_root             View current root project directory for Magento
    m2:set_autocomplete     Set/overwrite the autocomplete options
    m2:get_autocomplete     View current available/cached autocomplete options

For more information see:
    ${SCRIPT_DIR}/mage-2.plugin.zsh
";
    echo ${HELP_MSG}
}

# Main function that calls magento binary
function m2() {
	php $(m2:get_root)/bin/magento -vvv "$@"
}

# Set the root of your Magento directory.
# This will need to run before any other commands can execute
function m2:set_root() {
    [ "$1" != "" ] && echo "$1" > ${MAGE_ROOT_FILE}
    [ "$1" = "" ] && echo "Usage: m2:set_root <m2_root>\n"
}

# Retreive the m2 root set by m2:set_root
function m2:get_root() {
	[ ! -f ${MAGE_ROOT_FILE} ] && "Missing m2 root. Use m2:set_root"
    [ -f ${MAGE_ROOT_FILE} ] && cat ${MAGE_ROOT_FILE};
}

# Sets / overwrites autocomplete options.
# The autocomplete options are written to a file for quick retrieval.
# If you update Magento or add a new CLI option. You will need to run this
# to update your autocomplete options
function m2:set_autocomplete() {
    autocomplete=$(m2 --raw --no-ansi list | sed "s/[[:space:]].*//g")
    echo $autocomplete > ${MAGE_AUTOCOMPLETE_FILE}
}

# Gets the autocomplete options.
# If none are set/cached, we will do that action and then echo the results
function m2:get_autocomplete() {
	[ ! -f ${MAGE_AUTOCOMPLETE_FILE} ] && m2:set_autocomplete
    cat ${MAGE_AUTOCOMPLETE_FILE};
}

# Run on the zsh compdef function.
# This adds our autocomplete options
# This should not be called outsite this file
_m2:add_autocomplete () {
	compadd $(m2:get_autocomplete)
}

# Zsh default command
compdef _m2:add_autocomplete m2

# Aliases
alias m2:home="cd $(m2:get_root)"

