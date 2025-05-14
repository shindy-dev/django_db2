#!/bin/bash

nohup /usr/local/bin/runwebserver.sh > /var/log/shindjango.log 2>&1 &
