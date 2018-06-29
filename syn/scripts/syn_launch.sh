#!/usr/bin/env bash
# ===================================================================
# File: syn/scripts/syn_launch.sh
# NVDLA Open Source Project
# Control script for the reference synthesis methodology
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================

# Help function
usage ()
{
    echo Usage: $0 \[-build STRING\] \[-config /path/to/config\] -mode \[STRING\] -restore \[STRING\] -project \[STRING\] -modules \[STRING\];
    exit 1;
}

# Configure defaults
FLOW_ROOT=`dirname $0`
DEFAULT_FLOW_CONFIG=$FLOW_ROOT/default_config.sh

# Set up defaults. 
timestamp=$(date +%Y%m%d_%H%M)
config="./config.sh"
mode="wlm"
build="nvdla_syn_$timestamp"
modules=""
restore_db=""
qa_mode=""
project=nv_large

while [ $# -gt 0 ]
do
  case $1 in
      -config)
          error=0
          shift
          config="$1" ;;
      -mode)
          error=0
          shift
          mode="$1" ;;
      -modules)
          error=0
          shift
          modules="$1" ;;
      -build)
          error=0
          shift
          build="$1" ;;
      -restore)
          error=0
          shift
          restore_db="$1" ;;
      -project)
          error=0
          shift
          project="$1" ;;
      -qa_mode)
          error=0
          shift
          qa_mode="$1" ;;
        *)
          echo Error: unrecognized argument: $1
          usage ;; 
    esac
  shift
done

echo "[INFO]: Sourcing default flow variables from $DEFAULT_FLOW_CONFIG ... "
source $DEFAULT_FLOW_CONFIG

# Source config file
export PROJECT=$project
if [ ! -f "$config" ] ; then
    echo "[ERROR]: Please provide a valid config file."
    usage
fi
echo "[INFO]: Sourcing user synthesis configuration file $config ... "
source $config

# enable license queuing
export SNPSLMD_QUEUE=true

# If user is running QA mode, then pass that on to the TCL scripts
export QA_MODE="$qa_mode"

if [ -z "$modules" ] && [ -z "$TOP_NAMES" ] ; then
    echo "[ERROR]: TOP_NAMES cannot be empty. Aborting"
    exit
elif [ -z "$modules" ] ; then
    modules=$TOP_NAMES
fi

export BUILD_NAME=$build
export DB_DIR="$BUILD_NAME/db"
export CONS_DIR="$BUILD_NAME/cons"
export DEF_DIR="$BUILD_NAME/def"
export DLIB_DIR="$BUILD_NAME/design_lib"
export FV_DIR="$BUILD_NAME/fv"
export LOG_DIR="$BUILD_NAME/log"
export MW_DIR="$BUILD_NAME/mw"
export NET_DIR="$BUILD_NAME/net"
export REPORT_DIR="$BUILD_NAME/report"
export SCRIPTS_DIR="$BUILD_NAME/scripts"
export SEARCH_PATH=". $BUILD_NAME/src"
# Helper function to create BUILD sandbox
dataprep()
{
    if [ ! -d "$BUILD_NAME" ] ; then
        echo "[INFO]: Creating sandbox $BUILD_NAME ... "
        mkdir -p $BUILD_NAME
        mkdir -p $BUILD_NAME/cons
        mkdir -p $BUILD_NAME/log
        mkdir -p $BUILD_NAME/report
        mkdir -p $BUILD_NAME/db
        mkdir -p $BUILD_NAME/scripts
        mkdir -p $BUILD_NAME/design_lib
        mkdir -p $BUILD_NAME/mw
        mkdir -p $BUILD_NAME/fv
        mkdir -p $BUILD_NAME/def
        mkdir -p $BUILD_NAME/net
        mkdir -p $BUILD_NAME/src
        for module in $modules 
        do 
            mkdir -p $BUILD_NAME/fv/${module}
        done

        echo "[INFO]: Copying flow source code into $BUILD_NAME/scripts/ ..."
        cp -Lrf ${FLOW_ROOT}/* $BUILD_NAME/scripts/

        if [ "$DEF" != "" ] && [ -d "$DEF" ] ; then
            echo "[INFO]: Copying DEF files if available, into $BUILD_NAME/def..."
            cp -Lrf $DEF/* $BUILD_NAME/def/
        fi 
        if [ "$CONS" != "" ] && [ -d "$CONS" ] ; then
            echo "[INFO]: Copying constraint files if available, into $BUILD_NAME/cons ..."
            cp -Lrf $CONS/* $BUILD_NAME/cons/
        fi 
    fi
    
    echo "[INFO]: Searching for RTL with extension: $RTL_EXTENSIONS "
    for path in ${RTL_SEARCH_PATH}
    do 
        for ext in ${RTL_EXTENSIONS}
        do 
            cp -Lrf $path/*$ext $BUILD_NAME/src/ >& /dev/null
        done
    done
    
    echo "[INFO]: Searching for INCLUDE files with extension: $RTL_INCLUDE_EXTENSIONS "
    for path in ${RTL_INCLUDE_SEARCH_PATH}
    do 
        for ext in ${RTL_INCLUDE_EXTENSIONS}
        do 
            cp -Lrf $path/*$ext $BUILD_NAME/src/ >& /dev/null
        done 
    done
    
    EXTRA_RTL_LIST=""
    for file in ${EXTRA_RTL}
    do
        cp -Lrf $file $BUILD_NAME/src
        FILE_NAME=$(basename $file)
        EXTRA_RTL_LIST+=" $BUILD_NAME/src/$FILE_NAME"
    done
    echo "[INFO]: Copied all RTL and include files into $BUILD_NAME/src"
    
    
    echo "[INFO]: Removing any designware components from $BUILD_NAME/src"
    DW_FILES=$(echo $BUILD_NAME/src/DW_*)
    if [ ! -z "$DW_FILES" ] ; then
        rm -rf $BUILD_NAME/src/DW_*
    fi

    
    for module in $modules
    do
        rm -rf $BUILD_NAME/scripts/${module}.files.vc
        echo "-y $BUILD_NAME/src" > $BUILD_NAME/scripts/${module}.files.vc
        echo "+incdir+$BUILD_NAME/src" >> $BUILD_NAME/scripts/${module}.files.vc
        for ext in ${RTL_EXTENSIONS}
        do 
            echo "+libext+$ext" >> $BUILD_NAME/scripts/${module}.files.vc
        done

        echo "+define+DISABLE_TESTPOINTS" >> $BUILD_NAME/scripts/${module}.files.vc
        echo "+define+NV_SYNTHESIS " >> $BUILD_NAME/scripts/${module}.files.vc
        echo "+define+RAM_INTERFACE " >> $BUILD_NAME/scripts/${module}.files.vc
        echo "$module.v" >> $BUILD_NAME/scripts/${module}.files.vc

        # Common "library" modules
        for file in $EXTRA_RTL_LIST
        do
            echo " -v $file" >> $BUILD_NAME/scripts/${module}.files.vc
        done
        echo "[INFO]: Generated module input dependency file $BUILD_NAME/scripts/${module}.files.vc"

    done
}

# Run the data prep stage. 
if [ -z "$restore_db" ] ; then
    dataprep
fi


if [ -z "$DC_PATH" ] ; then
    echo "[ERROR]: DC_PATH cannot be empty. Aborting"
    exit 1
fi

if [ "$mode" == "dct" ] || [ "$mode" == "dcg"  ] ; then
    echo "[INFO]: Running DC - Topographical..."
    export SYN_MODE=$mode
    for module in $modules 
    do 
        export MODULE=$module
        export INSTANCE=`eval echo \\${TOP_INSTS_${module}}`
        export RTL_DEPS="$BUILD_NAME/scripts/${module}.files.vc"
        COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX/\<MODULE\>/$module}"
        COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX_PATCHED/\<LOG\>/$LOG_DIR}"
        if [ -z "$restore_db" ] ; then
            echo $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell-t -topographical_mode -no_gui -f $BUILD_NAME/scripts/dc_run.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.log
            $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell-t -topographical_mode -no_gui -f $BUILD_NAME/scripts/dc_run.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.log
        else
            export RESTORE_DB=$restore_db
            echo $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell-t -topographical_mode -f $BUILD_NAME/scripts/dc_interactive.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
            $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell-t -topographical_mode -f $BUILD_NAME/scripts/dc_interactive.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
        fi
    done
elif [ "$mode" == "wlm" ] ; then
    echo "[INFO]: Running DC (non-physical/Wireload model)..."
    export SYN_MODE=$mode
    for module in $modules
    do 
        export MODULE=$module
        export INSTANCE=`eval echo \\${TOP_INSTS_${module}}`
        export RTL_DEPS="$BUILD_NAME/scripts/${module}.files.vc"
        COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX/\<MODULE\>/$module}"
        COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX_PATCHED/\<LOG\>/$LOG_DIR}"
        if [ -z "$restore_db" ] ; then
            echo $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell -no_gui -f $BUILD_NAME/scripts/dc_run.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.log
            $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell -no_gui -f $BUILD_NAME/scripts/dc_run.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.log
        else
            export RESTORE_DB=$restore_db
            echo $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell-t -f $BUILD_NAME/scripts/dc_interactive.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
            $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell-t -f $BUILD_NAME/scripts/dc_interactive.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
        fi
    done
elif [ "$mode" == "de" ] ; then
    echo "[INFO] Running Design Explorer ..."
    export SYN_MODE=$mode
    for module in $modules
    do 
        export MODULE=$module
        export INSTANCE=`eval echo \\${TOP_INSTS_${module}}`
        export RTL_DEPS="$BUILD_NAME/scripts/${module}.files.vc"
        COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX/\<MODULE\>/$module}"
        COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX_PATCHED/\<LOG\>/$LOG_DIR}"
        if [ -z "$restore_db" ] ; then
            echo $COMMAND_PREFIX_PATCHED $DC_PATH/de_shell -no_gui -f $BUILD_NAME/scripts/dc_run.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
            $COMMAND_PREFIX_PATCHED $DC_PATH/de_shell -no_gui -f $BUILD_NAME/scripts/dc_run.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
        else
            export RESTORE_DB=$restore_db
            echo $COMMAND_PREFIX_PATCHED $DC_PATH/de_shell  -f $BUILD_NAME/scripts/dc_interactive.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
            $COMMAND_PREFIX_PATCHED $DC_PATH/de_shell -f $BUILD_NAME/scripts/dc_interactive.tcl -output_log_file $LOG_DIR/${module}_${SYN_MODE}.interactive.log
        fi
    done
else
    echo "[ERROR]: Unsupported option for -mode - Only supported modes are: \"wlm,dct,dcg,de\". Please refer the documentation for more details"
    exit 1
fi

