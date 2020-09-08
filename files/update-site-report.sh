#!/bin/bash
set -x

TMP_REPORT_PATH="/tmp/site-report-$(date +%s).json"
TARGET_REPORT_PATH="/storage/info/report.json"
if [ $# -gt 0 ]; then
    TARGET_REPORT_PATH=$1
fi

# refresh report
/usr/libexec/storm-info-provider get-report-json -o $TMP_REPORT_PATH

# copy report to storage area

cp $TMP_REPORT_PATH $TARGET_REPORT_PATH
chown storm:storm $TARGET_REPORT_PATH