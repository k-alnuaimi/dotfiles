function pingsweep --description 'Ping every address on a /24 subnet and list the devices that respond'
    # Usage: pingsweep            -> scans your current network (from the default gateway)
    #        pingsweep 192.168.0  -> scans 192.168.0.1 - 192.168.0.254

    if set -q argv[1]
        set -f subnet $argv[1]
    else
        set -l gw (route -n get default 2>/dev/null | awk '/gateway/ {print $2}')
        if test -z "$gw"
            echo "Couldn't find your default gateway. Pass a subnet, e.g.: pingsweep 192.168.1"
            return 1
        end
        set -f subnet (string replace -r '\.\d+$' '' -- $gw)
    end

    set -l tmp (mktemp)
    echo "Scanning $subnet.1 - $subnet.254 ..."

    # Ping all 254 addresses in parallel; record the ones that answer
    for i in (seq 1 254)
        sh -c "ping -c 1 -W 800 $subnet.$i >/dev/null 2>&1 && echo $subnet.$i >> $tmp" &
    end
    wait

    set -l found (sort -t . -k 4 -n $tmp)
    rm -f $tmp

    if test (count $found) -eq 0
        echo "No devices answered on $subnet.x"
        return 1
    end

    printf '\n%-16s %s\n' IP MAC
    printf '%-16s %s\n' ---------------- -----------------
    for ip in $found
        set -l mac (arp -n $ip 2>/dev/null | awk '{print $4}')
        if test -z "$mac"; or string match -q '*incomplete*' -- $mac
            set mac '(this Mac or unknown)'
        end
        printf '%-16s %s\n' $ip $mac
    end
    echo
    echo (count $found) "device(s) found. Match the MAC against the sticker on your TP-Link."
end
