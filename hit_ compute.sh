#!/bin/bash

# Timestamp for logging
echo "[$(date)] Hitting /compute endpoint..." >> /home/ubuntu/cron.log

# Actual request
curl -s http://127.0.0.1:5000/compute >> /home/ubuntu/cron.log
echo "" >> /home/ubuntu/cron.log
