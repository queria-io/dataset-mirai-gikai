{# インタビューの対話。1 行が 1 回の発言で、message_number の順に並べると対話になる #}

select
    report_id,
    m.ordinality::integer as message_number,
    m.message.role as speaker,
    m.message.content
from {{ ref('stg_interviews') }},
    unnest(messages) with ordinality as m(message, ordinality)
