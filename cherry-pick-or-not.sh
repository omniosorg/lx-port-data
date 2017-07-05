#!/bin/sh

if [ -z "$PORT_DATA" ]; then
	echo "PORT_DATA is not set, aborting."
	exit 0
fi

TODO=$PORT_DATA/ij-TODO-commits
DONE=$PORT_DATA/ij-decided-commits
PICKED=$PORT_DATA/ij-picked-commits
SKIPPED=$PORT_DATA/ij-skipped-commits

COMMIT=`head -1 $TODO`
if [ -z "$COMMIT" ]; then
	echo "$TODO appears to be empty."
	echo "You're done."
	exit 0
fi
git show --stat $COMMIT

echo "Cherry pick it (Y/N)? \\c"
read ANSWER

if [ "$ANSWER" == "Y" -o "$ANSWER" == "y" ]; then
	echo "GOING TO CHERRYPICK!"
	echo $COMMIT >> $DONE
	echo $COMMIT >> $PICKED
	sed -i "/$COMMIT/d" $TODO
	git cherry-pick $COMMIT
	echo "You're on your own now."
elif [ "$ANSWER" == "N" -o "$ANSWER" == "n" ]; then
	echo "GOING TO SKIP!"
	echo $COMMIT >> $DONE
	echo $COMMIT >> $SKIPPED
	sed -i "/$COMMIT/d" $TODO
	echo "Skipping this one."
else
	echo "ABORTING - You need to make up your mind."
fi

