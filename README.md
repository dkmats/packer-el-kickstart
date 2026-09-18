# Packer EL on VMware Workstation/Fusion 設定

Packer と Kickstart を使って、AlmaLinux / Rocky Linux のローカルテスト環境を VMware Workstation/Fusion 上で構築するための設定です。

x86_64 / aarch64 に対応しており、VMware の `vmware-iso` builder を使用します。

## 必要な環境

- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- [Packer VMware plugin](https://github.com/vmware/packer-plugin-vmware)
  - プロジェクトルートで `packer init .` を実行すると自動でインストールされます。
- [VMware Workstation / VMware Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)

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

`variables.auto.pkrvars.hcl` で変数を指定できます。

最低限、以下の項目を設定してください。

```hcl
arch             = "x86_64"
distribution     = "almalinux"
el_major_version = 10

ks = {
  template_path = "ks.cfg.tftpl"
  user = {
    ssh_pubkey = "ssh-ed25519 AAAA..."
  }
}
```

その他の変数、詳細な変数の説明やデフォルト値については、[`variables.pkr.hcl`](variables.pkr.hcl) を参照してください。
