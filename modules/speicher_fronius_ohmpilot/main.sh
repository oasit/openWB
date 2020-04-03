#!/bin/bash

#Auslesen eines Fronius Symo WR Hybrid mit Fronius Smartmeter und Batterie über die integrierte JSON-API des WR.
. /var/www/html/openWB/openwb.conf

speicherwatttmp=$(curl --connect-timeout 5 -s "$wrfroniusip/solar_api/v1/GetPowerFlowRealtimeData.fcgi?Scope?System")


speicherwatt=$(echo $speicherwatttmp | jq '.Body.Data.Smartloads.Ohmpilots."720896".P_AC_Total' |sed 's/\..*$//')

#wenn WR aus bzw. im standby (keine Antwort) ersetze leeren Wert durch eine 0
ra='^-?[0-9]+$'
if ! [[ $speicherwatt =~ $ra ]] ; then
		  speicherwatt="0"
fi

echo $speicherwatt > /var/www/html/openWB/ramdisk/speicherleistung

speichersoc=$(echo $speicherwatttmp | jq '.Body.Data.Smartloads.Ohmpilots."720896".Temperature' |sed 's/\..*$//')
if ! [[ $speichersoc =~ $ra ]] ; then
		  speichersoc="0"
fi


echo $speichersoc > /var/www/html/openWB/ramdisk/speichersoc

