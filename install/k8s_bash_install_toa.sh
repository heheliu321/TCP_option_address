#!/bin/bash
 
 
kubectl -n usg get node | grep -v NAME |awk '{print $1}'  | while read line 
do
bash -x bash_install.sh $line
done 
