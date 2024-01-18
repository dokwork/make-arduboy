#!/bin/bash

#==================================================
# This script is to build the compile_commands.json
#==================================================

bold() 
{ 
	echo -en "\033[1m$@\033[m" 
}

show_help()
{
cat <<EOF
$(bold NAME)
	$(bold commpiler_proxy.sh)

$(bold SYNOPSIS)
	$(bold commpiler_proxy.sh) <command> <output> [compiler, args ...]

$(bold DESCRIPTION)
	This script proxies all commands to the compiler and builds the 
	compile_commands.json it two steps:
	1. Generate command objects
	2. Create the compile_commands.json

$(bold COMMANDS)
	$(bold proxy)
		In this mode the script proxies all commands to the compiler, except a 
		command with -c flag. For such command a file 
		\$OUTPUT_DIR/compile_commands.objs with command objects will be
		generated.
	$(bold complete)
		In this mode the script takes the \$OUTPUT_DIR/compile_commands.objs, 
		makes it as a valid json array, and move it to the 
		\$PWD/compile_commands.json

$(bold ARGUMENTS)	
	$(bold output) 
		The path to the directory, where the file compile_commands.objs
		should be created or found.
	$(bold compiler)
		The compiler to which commands should be proxied.
	$(bold args) 
		the whole list of the compiler's arguments.

$(bold SEE ALSO)
	JSON Compilation Database Format Specification
	https://clang.llvm.org/docs/JSONCompilationDatabase.html

EOF
}

error()
{
	echo -e "\033[31m"$@"\033[m\n"
	exit -1
}

# Creates command objects and append them to the $OUTPUT_DIR/compile_commands.objs
generate_objs()
{
	# The whole command to the compiler (includes compiler it self):
	local command="$@"
	# Skip compiler:
	shift
	# Find source and output files:
	while [[ $# > 0 ]]; do
		if [[ $1 == '-'* ]]; then
			if [[ $1 == '-o' ]]; then
				output=$2
				shift
			fi
		else
			sources+=($1)
		fi
		shift
	done

	# generate entry of the compile_commands for every source:
	for source in $sources; do
		echo "{ \"directory\": \"$PWD\", \"file\": \"$source\", \"output\": \"$output\", \"command\": \"$command\" }"\
		>> $OUTPUT_DIR/compile_commands.objs
	done
}

# Choose mode:
case $1 in
	'proxy')
		# Getting output directory:
		OUTPUT_DIR=$2
		[[ -n $OUTPUT_DIR ]] || error 'The output directory must be specified as the second argument'
		mkdir -p $OUTPUT_DIR || error "The output directory '$OUTPUT_DIR' can't be created"
		# Getting compiler path:
		COMPILER=$3
		[[ -n $COMPILER ]] || error 'AVR compiler must be specified as the first argument'
		[[ -f $COMPILER ]] || error "Compiler '$COMPILER' not found"
		# and current working directory:
		PWD=$(pwd)
		# Skip already parsed arguments:
		shift 3
		# Generate command objects only if compilation is run:
		[[ $@ == *'-c'* ]] && generate_objs $COMPILER $@
		# Invoke compiler:
		$COMPILER "$@"
	;;
	'complete')
		# Getting output directory:
		OUTPUT_DIR=$2
		[[ -n $OUTPUT_DIR ]] || error 'The output directory must be specified as the second argument'
		# Check that compile_commands.objs exists:
		[[ -f $OUTPUT_DIR/compile_commands.objs ]] || error "The file '$OUTPUT_DIR/compile_commands.objs'
			with command objects was not found. Try to compile your project in the proxy mode."
		# Add a comma to the end of every line except the last one:
		sed  -i'' -e '$!s/$/,/' $OUTPUT_DIR/compile_commands.objs
		# Open array declaration:
		sed  -i'' -e '1s/^/[\n/' $OUTPUT_DIR/compile_commands.objs
		# Close array declaration:
		echo ']' >> $OUTPUT_DIR/compile_commands.objs
		cp $OUTPUT_DIR/compile_commands.objs compile_commands.json
	;;
	*)
		show_help
	;;
esac

