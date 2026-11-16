# ビルドと更新

データセットの概要は [README.md](README.md) にあります。ここにはこのリポジトリでデータセットをビルド・更新する手順を書きます。

## 開発

```bash
uv sync
uv run python -c "import main; main.download()"   # data/ に取得する
uv run dbt build --profiles-dir ci                 # 公開せずに手元の DuckDB に作る
scripts/build.sh                                    # 取得・dbt build・Queria への公開
```
