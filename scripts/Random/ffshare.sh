#!/usr/bin/env sh

resp=$(ffsend u -h https://send.adminforge.de "$@" --expiry-time 5m --password)

url=$(printf "$resp" | grep -oP "https://send.adminforge.de\S+")

printf "$url" | wl-copy; printf "\n\n$url\n"