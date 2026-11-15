{# インタビューの要約に挙がった意見。1 行が 1 件の意見 #}

with interviews as (
    select report_id, opinions from {{ ref('stg_interviews') }}
)

select
    report_id,
    o.ordinality::integer as opinion_number,
    o.opinion.title,
    o.opinion.content
from interviews,
    unnest(opinions) with ordinality as o(opinion, ordinality)
