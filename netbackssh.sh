#!/bin/bash
#IFS=$'\n' # Read till newline
PARAM="${1}"

if  [ $PARAM = poolstate ]; then
poolstate=$(ssh usr@addr-master-srv "/usr/openv/netbackup/bin/admincmd/nbdevquery -listdp -U | grep -E 'Down|DOWN'")
if [ -z "$poolstate" ]
then
      echo "0"
else
      echo $poolstate
fi
fi

if  [ $PARAM = test ]; then
ssh usr@addr-master-srv "/usr/openv/netbackup/bin/admincmd/nbdevquery -listdv -D "
fi


if [ $PARAM = frozenjobs ]; then
frozenjobs=$(ssh usr@addr-master-srv "/root/long_jobs.pl")
if [ -z "$frozenjobs" ]
then
      echo "0"
else
      echo $frozenjobs
fi
fi

if [ $PARAM = msdpused ]; then
IFS=$'\n' # Read till newline
poolused=$(ssh usr@addr-master-srv "/usr/openv/netbackup/bin/admincmd/nbdevquery -listdv -stype PureDisk -U | grep -E 'Pool|Use' | paste -d ' ' - -")
#echo ${poolused[@]}
FINARR=()
COUNTER=0
for i in ${poolused[@]}; do
        finarr=$(echo \{$i, \""{#ID}"\" : \"$COUNTER\"\}, | sed 's|Disk Pool Name|"{#NAME}"|g' | sed 's|Use%|\", \"Used\"|g' | sed 's|dp-msdp|\"dp-msdp|g')
        FINARR+=( ${finarr[@]})
        COUNTER=$((COUNTER+1))
done
echo \[${FINARR[@]}\] | sed 's|},]|}]|g' | jq
fi

if [ $PARAM = advused ]; then
IFS=$'\n' # Read till newline
poolused=$(ssh usr@addr-master-srv "/usr/openv/netbackup/bin/admincmd/nbdevquery -listdv -stype AdvancedDisk -U | grep -E 'Pool|Use' | paste -d ' ' - -")
FINARR=()
COUNTER=0
for i in ${poolused[@]}; do
        finarr=$(echo \{$i, \""{#ID}"\" : \"$COUNTER\"\}, | sed 's|Disk Pool Name|"{#NAME}"|g' | sed 's|Use%|\", \"Used\"|g' | sed 's|dp|\"dp|g')
        FINARR+=( ${finarr[@]})
        COUNTER=$((COUNTER+1))
done
echo \[${FINARR[@]}\] | sed 's|},]|}]|g' | jq
fi
         
