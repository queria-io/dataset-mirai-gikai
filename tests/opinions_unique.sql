select report_id, opinion_number
from {{ ref('opinions') }}
group by all
having count(*) > 1
