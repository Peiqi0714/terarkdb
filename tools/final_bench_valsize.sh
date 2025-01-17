rm -rf /users/peiqi714/test/valsize_log/*
rm -rf /users/peiqi714/test/db/*
thread_count=1
echo "start final exp valsize"
for val_size in 2048 4096 8192 16384
do
    entry_count=$((50000000/(val_size / 1024)))
    echo "entry count: $entry_count"

    rm -rf /users/peiqi714/test/db/*
    ./db_bench --benchmarks=fillrandom,stats,overwrite,stats,overwrite,stats,overwrite,stats  --db=/users/peiqi714/test/db/db --threads=$thread_count \
                    --statistics=true  --num=$entry_count --zipfian=1 --zipf_const=0.9 \
                    --key_size=16 --value_size=$val_size --compression_type=none --compression_ratio=1 \
                    --blob_gc_ratio=0.3 --blob_size=512 --target_file_size_base=4194304 \
                    --max_bytes_for_level_base=16777216 --target_blob_file_size=67108864 > /users/peiqi714/test/valsize_log/lavakv_valsize${val_size}
    echo "lavakv_valsize${val_size} space:" >> /users/peiqi714/test/valsize_log/space_util_valsize
    du -k --max-depth=0 /users/peiqi714/test/db/db >> /users/peiqi714/test/valsize_log/space_util_valsize
    cp -f /users/peiqi714/test/db/db/LOG /users/peiqi714/test/valsize_log/lavakv_valsize${val_size}_log

done
echo "end final exp valsize"