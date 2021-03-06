#!/usr/bin/env bash
HERE=$(cd "$(dirname "$0")";pwd)

rm -rf $HERE/tracker
mkdir -p $HERE/tracker

if [ ! -d "$HERE/data" ]; then
  mkdir -p $HERE/data
  python $HERE/gen_test_data.py
fi

python $HERE/test.py \
  --cluster="{\"client_count\": 2, \"tracker\": \"$HERE/tracker\", \"server_count\": 2}" \
  --job_name="server" --task_index=0 &
sleep 1
python $HERE/test.py \
  --cluster="{\"client_count\": 2, \"tracker\": \"$HERE/tracker\", \"server_count\": 2}" \
  --job_name="server" --task_index=1 &
sleep 1
python $HERE/test.py \
  --cluster="{\"client_count\": 2, \"tracker\": \"$HERE/tracker\", \"server_count\": 2}" \
  --job_name="client" --task_index=0 &
sleep 1
python $HERE/test.py \
  --cluster="{\"client_count\": 2, \"tracker\": \"$HERE/tracker\", \"server_count\": 2}" \
  --job_name="client" --task_index=1 &
