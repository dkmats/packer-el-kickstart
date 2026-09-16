# Kickstart

Kickstart を使って、AlmaLinux / Rocky Linux のローカルテスト環境を Packer で構築するための設定です。

x86_64 / aarch64 に対応しており、VMware の `vmware-iso` builder を使用します。

## 必要な環境

* Packer
* VMware Workstation または VMware Fusion

Packer プラグインは `packer init` 実行時に自動で取得されます。

## 使い方

Packer プラグインを初期化します。

```sh
packer init .
```

`variables.auto.pkrvars.hcl` に変数を設定してビルドします。

```sh
packer build .
```

## 必要な設定項目

最低限、以下の項目を設定してください。

```hcl
arch             = "aarch64"
distribution     = "almalinux"
el_major_version = 10

ks_template_path = "ks.cfg.tftpl"

ks = {
  user = {
    ssh_pubkey = "ssh-ed25519 AAAA..."
  }
}
```

詳細な変数の説明やデフォルト値については、[`variables.pkr.hcl`](variables.pkr.hcl) を参照してください。
