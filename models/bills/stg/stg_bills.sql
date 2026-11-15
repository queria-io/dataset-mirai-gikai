select
    billId as bill_id,
    name,
    status,
    statusLabel as status_label,
    originatingHouse as originating_house,
    cast(timezone('Asia/Tokyo', cast(submittedDate as timestamptz)) as date) as submitted_date,
    cast(publishedAt as timestamptz) as published_at,
    'https://gikai.team-mir.ai/bills/' || billId as url
from {{ ref('raw_bills') }}
