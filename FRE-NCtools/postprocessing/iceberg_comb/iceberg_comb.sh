#!/bin/sh

echoerr() {
    echo "$@" 1>&2
}

help_usage() {
    echo "usage: ${myCommand} [options] <in_file> [<in_file> ...] <out_file>"
}

help_options() {
    echo "options:"
    echo "    -h              Print help message"
    echo "    -v              Be verbose in output"
    echo "    -V              Print the version and exit"
}

help() {
    help_usage
    echo ""
    help_options
    exit 0
}

# Name of the command
myCommand=$( basename $0 )
# Other global variables
verbose=0
version="0.0.1"

while getopts :hvV OPT; do
    case "$OPT" in
        h)
            help
            exit 0
            ;;
        v)
            (( verbose++ ))
            ;;
        V)
            echo "${myCommand}: Version ${version}"
            exit 0
            ;;
        \?)
            echoerr "${myCommand}: unknown option: -${OPTARG}"
            echoerr ""
            help_usage >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Check that at least 2 arguments have been passed in
if [ $# -lt 2 ]; then
    echoerr "ERROR: Not enough arguments given"
    help_usage
    exit 1
fi

# Verify the ncdump executable is in PATH and is executable
ncdumpPath=$( which ncdump 2>&1 )
if [ $? -ne 0 ]; then
    echo "ERROR: Required command 'ncdump' is not in PATH."
    exit 1
else
    if [ ! -x $ncdumpPath ]; then
        echoerr "ERROR: Required command 'ncdump' is not executable ($ncdumpPath)."
        exit 1
    fi
fi

# Verify the ncrcat executable is in PATH and is executable (`ncrcat --version` exit status of 0)
which ncrcat > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echoerr "ERROR: NCO command 'ncrcat' is not in PATH."
    exit 1
else
    # Check that ncrcat is executable
    ncrcat --version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echoerr "ERROR: NCO command 'ncrcat' is not executable."
        exit 1
    fi
fi

# All of the input files (<iceberg_res_file> [<iceberg_res_file> ...] need to exist.
# <iceberg_out_file> must NOT exist, and should fail if the file exists (unless an -o option given?).

icebergFiles=""  # list of files with icebergs
while [ $# -gt 0 ]; do
    curFile=$1; shift
    if [ $# = 0 ]; then
        # This is the last file listed, and is the output file
        # Exit if this file exists
        if [[ -e $curFile ]]; then
            echoerr "ERROR: out file '$curFile' exists.  Refusing to overwrite file."
            exit 1
        else
            if [ $verbose -gt 1 ]; then
                echoerr "Out file: $curFile"
            fi
            outFile=$curFile
        fi
    else
        # The in files must exist
        if [[ ! -e $curFile ]]; then
            echoerr "ERROR: in file '$curFile' does not exist."
            exit 1
        else
            ncdumpOut=$( ncdump -h $curFile 2>&1 )
            status=$?
            if [ $status -ne 0 ]; then
                echoerr "WARNING: skipping in file '$curFile' as it is NOT a NetCDF formatted file."
            else
                # Check each iceberg_res_file to see if it has icebergs.
                if [ $( echo "$ncdumpOut" | grep 'UNLIMITED' | awk '{gsub(/\(/," ");print $6}' ) -gt 0 ]; then
                    if [ $verbose -gt 1 ]; then
                        echoerr "Using input file $curFile"
                    fi
                    icebergFiles="$icebergFiles $curFile"
                fi
            fi
        fi
    fi
done

# Collect the group of files that do have icebergs, and pass that to ncrcat
if [ "X$icebergFiles" = "X" ]; then
    echoerr "No files to record concatenate."
else
    ncrcat_cmd="ncrcat $icebergFiles $outFile"
    if [ $verbose -gt 0 ]; then
        echo $ncrcat_cmd
    fi
    eval $ncrcat_cmd
fi
