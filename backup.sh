#!/bin/bash

set -a
. /etc/backup/b2.cfg
. /etc/backup/restic.cfg

# --quiet - should speed up backup process
#      see: https://github.com/restic/restic/pull/1676
restic backup /mnt/ext/photos \
	--quiet \
	--exclude-caches

# remove outdated snapshots
# --prune - delete repositories which should be forgotten
restic forget \
	--keep-last 20 \
	--keep-daily 7 \
	--keep-weekly 4 \
	--keep-monthly 6 \
	--keep-yearly 3 \
	--limit-upload 500 \
	--prune

# --with-cache - limits Class B Transactions on Backblaze B2
#      see: https://forum.restic.net/t/limiting-b2-transactions/209/8
restic check --with-cache
