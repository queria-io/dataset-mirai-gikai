"""みらい議会のオープンデータ API から、法案とAIインタビューを取得する。

API は 1 回に 20 件ずつ返し、続きがあれば nextCursor を返す。毎回すべてを取得し直す。
インタビューの利用規約は、公開の対象から外れたデータを使い続けないことを求めるため、
前回の取得結果は残さずに置き換える。

インタビューは、利用規約に同意したことを示す agreeToTerms=true を付けないと 403 になる。

出力: data/bills.ndjson.gz、data/interviews.ndjson.gz

データソース: みらい議会 オープンデータAPI
https://gikai.team-mir.ai/developers
"""

import gzip
import json
import logging
import time
from pathlib import Path
from urllib.parse import urlencode

from shared.fetch import fetch, replacing

logger = logging.getLogger("pipelines")

BASE = "https://gikai.team-mir.ai/api/open-data/"
USER_AGENT = "dataset-mirai-gikai (+https://github.com/queria-io/dataset-mirai-gikai)"
OUTPUT = Path("data")
INTERVAL_SECONDS = 1.0
ENDPOINTS = {"bills": {}, "interviews": {"agreeToTerms": "true"}}


def items(endpoint: str, params: dict, cursor: str | None = None) -> list[dict]:
    """1 つのエンドポイントの全件を、nextCursor をたどって返す。"""
    query = urlencode({**params, **({"cursor": cursor} if cursor else {})})
    page = json.loads(fetch(f"{BASE}{endpoint}?{query}", user_agent=USER_AGENT))
    time.sleep(INTERVAL_SECONDS)
    rest = items(endpoint, params, page["nextCursor"]) if page.get("nextCursor") else []
    return page["items"] + rest


def write(path: Path, rows: list[dict]) -> None:
    if not rows:
        raise SystemExit(f"{path.name}: 0 件（API の形が変わった？）")
    path.parent.mkdir(parents=True, exist_ok=True)
    with replacing(path) as partial, gzip.open(partial, "wt", encoding="utf-8") as f:
        f.writelines(json.dumps(row, ensure_ascii=False) + "\n" for row in rows)


def download(output: Path = OUTPUT) -> None:
    for endpoint, params in ENDPOINTS.items():
        rows = items(endpoint, params)
        write(output / f"{endpoint}.ndjson.gz", rows)
        logger.info("  %s: %d 件", endpoint, len(rows))
