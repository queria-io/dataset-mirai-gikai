"""みらい議会のオープンデータのパイプライン。

1. download: オープンデータ API から法案とAIインタビューを取得する
2. dbt: dbt ビルド
"""

import logging

from dbt.cli.main import dbtRunner

from pipelines.open_data import download as download_open_data

# dbt を読み込むとルートロガーが先に設定されるので、force で上書きする
logging.basicConfig(level=logging.INFO, format="%(message)s", force=True)
logger = logging.getLogger("pipelines")


def dbt_build():
    dbt = dbtRunner()
    for command in (["deps"], ["build"], ["docs", "generate"]):
        if not dbt.invoke(command).success:
            raise SystemExit(f"dbt {' '.join(command)} failed")


def download() -> None:
    logger.info("1/2: download (法案・AIインタビュー)")
    download_open_data()


def main():
    download()
    logger.info("2/2: dbt build")
    dbt_build()


if __name__ == "__main__":
    main()
