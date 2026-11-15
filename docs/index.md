# みらい議会

チームみらいが運営する[みらい議会](https://gikai.team-mir.ai/)の[オープンデータ API](https://gikai.team-mir.ai/developers)から、国会の法案の一覧と、法案についてのAIインタビューの回答を取得して SQL で検索できるテーブルにしたデータセットです。

| テーブル | 内容 |
| --- | --- |
| `bills.bills` | 1 行が 1 件の法案。法案名・審議状況・先議院・提出日・みらい議会の URL |
| `interviews.reports` | 1 行が 1 件のAIインタビュー。法案・賛否・回答者の立場・要約 |
| `interviews.opinions` | 1 行が、インタビューの要約に挙がった 1 件の意見 |
| `interviews.messages` | 1 行が、インタビューの対話の 1 回の発言 |

- 毎日、API からすべてを取得し直します。公開の対象から外れたインタビューは、次の取得で消えます
- 法案のテーブルは、法案を特定する項目と審議の状況だけを持ちます。解説の文章はみらい議会の法案のページ（`url`）で読めます
- 法案名は衆議院の議案の件名と同じ書き方なので、`shugiin.bills.bills` の `title` と結合できます。同じ件名の議案が複数の国会にあるとき（毎年の給与法の改正など）は、提出日と衆議院の議案受理年月日で区別します
- 2 件の法案をまとめた行は、法案名が「、」で区切って並びます

## 使い方

法案ごとのインタビューの件数と賛否:

```sql
SELECT bill_name, count(*) AS reports,
       count(*) FILTER (WHERE stance = 'for') AS for_,
       count(*) FILTER (WHERE stance = 'against') AS against
FROM mirai_gikai.interviews.reports
GROUP BY bill_name
ORDER BY reports DESC;
```

法案に衆議院の議案番号と法令番号を付ける:

```sql
SELECT m.name, m.submitted_date, s.bill_type, s.submitted_session, s.bill_number, s.status, s.law_num
FROM mirai_gikai.bills.bills AS m
JOIN shugiin.bills.bills AS s ON s.title = m.name
QUALIFY row_number() OVER (
  PARTITION BY m.bill_id
  ORDER BY abs(date_diff('day', s.shu_received_date, m.submitted_date))
) = 1;
```

## 利用条件

AIインタビューは[みらい議会AIインタビューデータ利用規約](https://gikai.team-mir.ai/developers/interview-data-terms)に従い、CC BY 4.0 で利用できます。成果物には次の 4 点を表示します。

- データ出典：「みらい議会AIインタビュー（チームみらい）」
- データ提供元URL：https://gikai.team-mir.ai/
- 本規約のURL：https://gikai.team-mir.ai/developers/interview-data-terms
- ライセンス：CC BY 4.0

回答者やその関係者を識別・推測すること、そのために他の情報と照合することは、利用規約で禁止されています。
