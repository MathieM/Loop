#!/bin/sh


if [ -f $PROJECT_DIR/.gitmodules ]; then
    echo "Skipping checkout due to presence of .gitmodules file"
    if [ $ACTION = "install" ]; then
        echo "You're installing: Make sure to keep all submodules up-to-date and run carthage build after changes."
    fi
else
    echo "Bootstrapping carthage dependencies"
    ./Scripts/carthage.sh bootstrap --project-directory "$SRCROOT" --platform ios,watchos --cache-builds --verbose
fi

