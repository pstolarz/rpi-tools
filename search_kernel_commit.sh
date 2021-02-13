#!/bin/sh
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 kernel_ver"
  exit 0
else
  KERNEL_VER=$1
fi

srch_res=`mktemp`

clean_up() {
  rm -f $srch_res
}
trap clean_up EXIT

curl -sGH "Accept: application/vnd.github.cloak-preview+json" \
  --data-urlencode "q=\"kernel: Bump to $KERNEL_VER\" repo:raspberrypi/firmware" \
  --data-urlencode "per_page=100" \
  https://api.github.com/search/commits > $srch_res

commits=$(cat $srch_res | jq -r '.items[].sha')

res_n=$(echo $commits | wc -w)
if [ $res_n -gt 0 ]; then
  i=0
  echo $res_n" result(s) for kernel $KERNEL_VER [max. 100]"

  for fw_commit in $commits; do
    msg=$(cat $srch_res | jq -r ".items[$i].commit.message" | awk '{print($0); exit(0)}')

    ker_commit=$(wget -qO - \
      https://raw.githubusercontent.com/raspberrypi/firmware/$fw_commit/extra/git_hash)

    echo "  raspberrypi/linux: "$ker_commit", raspberrypi/firmware: "$fw_commit" ["$msg"]"
    i=$((i+1))
  done
else
  echo "No results for kernel $KERNEL_VER"
fi
