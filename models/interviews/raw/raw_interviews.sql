{# インタビュー (data/interviews.ndjson.gz)。取得したままの形 #}

select * from read_json('data/interviews.ndjson.gz', format = 'newline_delimited')
