{# 法案ごとに 1 行。解説の文章（title・summary など）とチームみらいの賛否は持たず、
   法案を特定する項目と審議の状況だけを取り出す #}

select * from {{ ref('stg_bills') }}
