#! /bin/bash

########################################
# Shell log print functions
#
# Author : zhengweihua
# Date   : 2016-02-05 11:00:00
########################################

function _log()
{
    local date_time=$(date +"%F %T")
    local script_name=$0
    local flag=$1
    local msg=$2
    echo "${date_time} ${script_name} [${flag}] : ${msg}"
}

function log_trace()
{
    _log "TRACE" "$1"
}

function log_debug()
{
    _log "DEBUG" "$1"
}

function log_info()
{
    _log "INFO" "$1"
}

function log_warn()
{
    _log "WARN" "$1"
}

function log_error()
{
    _log "ERROR" "$1"
}

function log_fatal()
{
    _log "FATAL" "$1"
}

function log_notice()
{
    _log "NOTICE" "$1"
}

function set_file_lock()
{
    if [[ $# -ne 2 ]]
    then
        echo "--> Usage : set_file_lock [job_directory] [job_name]"
        exit 1
    fi

    local job_dir=$1
    local job_name=$2
    local lock_file="${job_dir}/${job_name}.lock"

    if [[ -s ${lock_file} ]]
    then
        local pid_status=$(ps aux | awk -v pid=$(cat ${lock_file}) '{ if($2==pid) { print "OK"; exit; } }')
        if [[ "${pid_status}" == "OK" ]]
        then
            echo "--> ${job_name} is now running, will not start a new job"
            exit 1
        fi
    fi

    echo $$ > ${lock_file}
    if [[ $? -eq 0 ]]
    then
        echo "--> set lock file : ${lock_file}"
    else
        echo "--> set lock file failed"
        exit 1
    fi
}

function remove_file_lock()
{
    if [[ $# -ne 2 ]]
    then
        echo "--> Usage : set_file_lock [job_directory] [job_name]"
        exit 1
    fi

    local job_dir=$1
    local job_name=$2
    local lock_file="${job_dir}/${job_name}.lock"

    if [[ -s ${lock_file} ]]
    then
        rm ${lock_file}
        if [[ $? -eq 0 ]]
        then
            echo "--> remove lock file : ${lock_file}"
        else
            echo "--> remove lock file failed"
            exit 1
        fi
    else
        echo "--> no lock file to remove"
    fi
}
