#!/bin/bash

service munge restart
service slurmctld restart
service slurmd restart
sinfo