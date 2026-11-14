{# 法案ごとに 1 行。解説の文章（title・summary など）とチームみらいの賛否は持たず、
   法案を特定する項目と審議の状況だけを取り出す #}
select
    billId as bill_id,
    name,
    status,
    statusLabel as status_label,
    originatingHouse as originating_house,
    cast(timezone('Asia/Tokyo', cast(submittedDate as timestamptz)) as date) as submitted_date,
    cast(publishedAt as timestamptz) as published_at,
    'https://gikai.team-mir.ai/bills/' || billId as url
from read_json('data/bills.ndjson.gz', format = 'newline_delimited', columns = {
    billId: 'varchar', name: 'varchar', status: 'varchar', statusLabel: 'varchar',
    originatingHouse: 'varchar', submittedDate: 'varchar', publishedAt: 'varchar'
})
