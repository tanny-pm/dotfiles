DOTFILES := $(HOME)/dev/dotfiles
PACKAGES := zsh git starship zed claude
STOW     := stow -d $(DOTFILES) -t $(HOME)

.PHONY: help install stow unstow restow check brew

help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: brew stow ## brew一括導入 + stowリンク作成

stow: ## ホームにシンボリックリンクを作成
	$(STOW) $(PACKAGES)

unstow: ## シンボリックリンクを解除
	$(STOW) -D $(PACKAGES)

restow: ## リンクを張り直す（追加/削除の反映）
	$(STOW) -R $(PACKAGES)

check: ## 衝突チェック（dry-run、実際には変更しない）
	$(STOW) -n -v $(PACKAGES)

brew: ## Brewfile から一括インストール
	brew bundle --file=$(DOTFILES)/Brewfile
