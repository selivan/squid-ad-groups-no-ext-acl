#!/bin/bash

# Gets users for AD groups named as listed files
# If group content changed, updates corresponding file

updated=0

find /etc/squid3/groups/ -type f | while read file; do
    group=`basename "$file"`
    temp=`mktemp --tmpdir=/run`
    wbinfo --group-info "$group" | cut -d: -f 4 | tr ',' '\n' | sort > "$temp"
    # If we failed to get users from group
    [ $? -ne 0 ] && continue
    # Check, if group changed
    cmp "$file" "$temp" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Group $group in file $file updated"
        mv -f "$temp" "$file"
        updated=1
    else
        rm "$temp" -f
    fi
    #sleep 10
done

if [ $updated -ne 0 ]; then
    echo "Trying to reload squid3"
    service squid3 reload
    echo "Result: $?"
fi
