rm -rf /users/peiqi714/test/update_log/*
rm -rf /users/peiqi714/test/db/*
thread_count=1
echo "start final exp update"
for val_size in 1024
do
    entry_count=50000000
    echo "entry count: $entry_count"

    rm -rf /users/peiqi714/test/db/*
    ./db_bench --benchmarks=fillrandom,stats,overwrite,stats,overwrite,stats,overwrite,stats  --db=/users/peiqi714/test/db/db --threads=$thread_count \
                    --statistics=true  --num=$entry_count --zipfian=1 --zipf_const=0.9 \
                    --key_size=16 --value_size=$val_size --compression_type=none --compression_ratio=1 \
                    --blob_gc_ratio=0.3 --blob_size=512 --target_file_size_base=4194304 \
                    --max_bytes_for_level_base=16777216 --target_blob_file_size=67108864 > /users/peiqi714/test/update_log/lavakv_update
    echo "lavakv_update space:" >> /users/peiqi714/test/update_log/space_util_update
    du -k --max-depth=0 /users/peiqi714/test/db/db >> /users/peiqi714/test/update_log/space_util_update
    cp -f /users/peiqi714/test/db/db/LOG /users/peiqi714/test/update_log/lavakv_update_LOG

done
echo "end final exp update"

rm -rf /users/peiqi714/test/base_log/*
rm -rf /users/peiqi714/test/db/*
thread_count=1
echo "start final exp base"
do
    entry_count=50000000
    read_count=5000000
    echo "entry count: $entry_count"
    echo "read count: $read_count"

    rm -rf /users/peiqi714/test/db/*
    ./db_bench --benchmarks=fillrandom,stats,overwrite,stats,readrandom,stats,seekrandom,stats  --db=/users/peiqi714/test/db/db --threads=$thread_count \
                    --statistics=true  --num=$entry_count --reads=$read_count --seek_nexts=10 --zipfian=1 --zipf_const=0.9 \
                    --key_size=16 --value_size=1024 --compression_type=none --compression_ratio=1 \
                    --blob_gc_ratio=0.3 --blob_size=512 --target_file_size_base=4194304 \
                    --max_bytes_for_level_base=16777216 --target_blob_file_size=67108864 > /users/peiqi714/test/base_log/lavakv_base
    echo "lavakv_base space:" >> /users/peiqi714/test/base_log/space_util_base
    du -k --max-depth=0 /users/peiqi714/test/db/db >> /users/peiqi714/test/base_log/space_util_base
    cp -f /users/peiqi714/test/db/db/LOG /users/peiqi714/test/base_log/lavakv_base_LOG

done
echo "end final exp base"

rm -rf /users/peiqi714/test/ycsb_log/*
rm -rf /users/peiqi714/test/db/*
thread_count=1
echo "start final exp ycsb"
for wkld in ycsbwklde ycsbwklda ycsbwkldb ycsbwkldc ycsbwkldd ycsbwkldf
do
    entry_count=50000000
    echo "entry count: $entry_count"

    rm -rf /users/peiqi714/test/db/*
    ./db_bench --benchmarks=ycsbfilldb,stats,ycsbupdate,stats,${wkld},stats  --db=/users/peiqi714/test/db/db --threads=$thread_count \
                    --statistics=true  --num=$entry_count --ycsb_num=$entry_count \
                    --key_size=16 --value_size=1024 --compression_type=none --compression_ratio=1 \
                    --blob_gc_ratio=0.3 --blob_size=512 --target_file_size_base=4194304 \
                    --max_bytes_for_level_base=16777216 --target_blob_file_size=67108864 > /users/peiqi714/test/ycsb_log/lavakv_${wkld}
    echo "lavakv_${wkld} space:" >> /users/peiqi714/test/ycsb_log/space_util_ycsb
    du -k --max-depth=0 /users/peiqi714/test/db/db >> /users/peiqi714/test/ycsb_log/space_util_ycsb
    cp -f /users/peiqi714/test/db/db/LOG /users/peiqi714/test/ycsb_log/lavakv_${wkld}_LOG

done
echo "end final exp ycsb"




