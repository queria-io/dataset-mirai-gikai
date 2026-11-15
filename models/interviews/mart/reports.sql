{# インタビュー 1 件に 1 行。意見（opinions）と対話（messages）は別のテーブル #}

select * exclude (opinions, messages)
from {{ ref('stg_interviews') }}
