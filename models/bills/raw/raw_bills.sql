{# 法案の一覧 (data/bills.ndjson.gz)。法案を特定する項目と審議の状況の列だけを読む #}

select *
from read_json('data/bills.ndjson.gz', format = 'newline_delimited', columns = {
    billId: 'varchar', name: 'varchar', status: 'varchar', statusLabel: 'varchar',
    originatingHouse: 'varchar', submittedDate: 'varchar', publishedAt: 'varchar'
})
