{# インタビュー 1 件に 1 行。意見（opinions）と対話（messages）はリストのまま持つ #}

select
    cast(reportId as varchar) as report_id,
    cast(billId as varchar) as bill_id,
    billName as bill_name,
    stance,
    role,
    roleTitle as role_title,
    roleDescription as role_description,
    summary,
    cast(createdAt as timestamptz) as created_at,
    opinions,
    messages
from {{ ref('raw_interviews') }}
