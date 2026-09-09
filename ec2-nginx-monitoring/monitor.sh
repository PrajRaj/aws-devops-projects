#!/bin/bash
#################################
# Author: Prajwal Raj
# Title: Monitor server performance
#################################

echo "=============================="
echo "    SERVER HEALTH REPORT      "
echo "  Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================="

echo -e "\n[1] DISK USAGE:"
df -h /

echo -e "\n[2] MEMORY USAGE:"
free -h

echo -e "\n[3] CPU CORES:"
nproc

echo -e "\n=============================="
echo "        END OF REPORT         "
echo "=============================="
