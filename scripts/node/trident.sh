#!/bin/bash

wget https://github.com/NetApp/trident/releases/download/v20.01.0/trident-installer-20.01.0.tar.gz

tar -xf trident-installer-20.01.0.tar.gz

cp trident-installer/tridentctl /usr/local/bin
