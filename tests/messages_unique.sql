select report_id, message_number
from {{ ref('messages') }}
group by all
having count(*) > 1
