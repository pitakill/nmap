#!/bin/sh

# Change to the working directory because the file is going to be stored here,
# so the host can mount a volume to this directory and recover the output file
cd /workdir || exit

# Helper function from: https://www.shellscript.sh/tips/spinner/
spin()
{
  spinner="/|\\-/|\\-"
  while :
  do
    for i in $(seq 0 7)
    do
      printf "%s" "${spinner:$i:1}"
      printf "%b" "\010"
      sleep 1
    done
  done
}

# Common vars
#LINE="================================================================================"
NETWORK_HOSTS=$(ip a show eth0 | grep 'inet' | awk '{print $2}')
#DEFAULT_ROUTE=$(ip route | grep default | awk '{print $3}')

# Start knowing which hosts are in the same network
printf "Scanning: %s\n\n" "$NETWORK_HOSTS"

# Spinner
spin &
SPIN_PID=$!
trap 'kill -9 $SPIN_PID' $(seq 0 15)

nmap "$NETWORK_HOSTS" 2>&1 | tee network-scan.txt

kill -9 $SPIN_PID
