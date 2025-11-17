#!/bin/bash
DIR="data"

if [ ! -d "$DIR" ]; then
	mkdir "$DIR"
fi

sudo chown 10001:0 "$DIR"
sudo chmod 755 "$DIR"
