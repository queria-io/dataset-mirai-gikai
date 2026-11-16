---
$schema: https://queria.io/schemas/table/v1.json
table: interviews.opinions
title: AIインタビューの意見
description: AIインタビューの要約に挙がった意見です。1 行が 1 件の意見です。
primary_key: [report_id, opinion_number]
sources:
  - title: みらい議会 オープンデータAPI
    path: https://gikai.team-mir.ai/api/open-data/interviews
fields:
  - name: report_id
    title: インタビュー ID
    description: interviews.reports の report_id と結合できる
  - name: opinion_number
    title: 番号
    description: インタビューの中での意見の順番。1 から始まる
  - name: title
    title: 意見の見出し
  - name: content
    title: 意見の内容
---
