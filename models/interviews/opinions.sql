{# インタビューの要約に挙がった意見。1 行が 1 件の意見 #}
select
    cast(reportId as varchar) as report_id,
    o.ordinality::integer as opinion_number,
    o.opinion.title,
    o.opinion.content
from {{ source('raw', 'interviews') }},
    unnest(opinions) with ordinality as o(opinion, ordinality)
