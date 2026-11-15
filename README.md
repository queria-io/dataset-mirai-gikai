# dataset-mirai-gikai

Queria のデータセット `mirai_gikai`（みらい議会）のリポジトリです。データセットの説明は [docs/index.md](docs/index.md) にあります。

## 開発

```bash
uv sync
uv run python -c "import main; main.download()"   # data/ に取得する
uv run dbt build --profiles-dir ci                 # 公開せずに手元の DuckDB に作る
scripts/build.sh                                    # 取得・dbt build・Queria への公開
```
