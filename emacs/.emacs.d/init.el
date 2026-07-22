;; ========================A==================
;; ターミナル専用・UI設定（必須要件）
;; ==========================================
;; ターミナル上部に出るテキストのメニューバーを非表示
(menu-bar-mode -1)

;; ターミナルの背景色・文字色をそのまま引き継ぐ
(unless (display-graphic-p)
  (set-face-background 'default "unspecified-bg")
  (set-face-foreground 'default "unspecified-fg"))

;; ==========================================
;; 推奨される基本設定
;; ==========================================
;; スタートアップ画面を表示しない
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;; ビープ音を無効化
(setq ring-bell-function 'ignore)

;; yes/no の確認プロンプトを y/n で済ませる
(defalias 'yes-or-no-p 'y-or-n-p)

;; 対応するカッコを強調表示する
(show-paren-mode 1)

;; タブを使わずスペースでインデントする
(setq-default indent-tabs-mode nil)

;; バックアップファイル (*~) を作成しない
(setq make-backup-files nil)

;; オートセーブファイル (.#*) を作成しない
(setq auto-save-default nil)

;; 外部（別のエディタやgitなど）でファイルが変更されたら自動で読み直す
(global-auto-revert-mode 1)

;; ==========================================
;; ターミナルの背景・文字色・シンタックスハイライトを完全同期
;; ==========================================
(unless (display-graphic-p)
  (custom-set-faces
   ;; 1. 全体の背景と文字色を透過（ターミナルを引き継ぐ）
   '(default ((t (:background "unspecified-bg" :foreground "unspecified-fg"))))
   
   ;; 2. シンタックスハイライトをターミナルの ANSI 色に委譲する。
   ;;    ANSI の意味的な色名だけを使うので、Ghostty のテーマを
   ;;    切り替えるとハイライトもそのパレットに追従する。
   ;;    （"blue" は Monokai Classic では橙にマップされる等、
   ;;      スロットの割り当てがテーマ依存で大きくブレるため使わない）
   '(font-lock-comment-face ((t (:foreground "brightblack"))))            ; コメント（淡いグレー）
   '(font-lock-comment-delimiter-face ((t (:foreground "brightblack"))))  ; コメント記号 ;; //
   '(font-lock-doc-face ((t (:foreground "brightblack"))))                ; ドキュメント文字列
   '(font-lock-string-face ((t (:foreground "yellow"))))                  ; 文字列
   '(font-lock-keyword-face ((t (:foreground "red"))))                    ; キーワード (if, for等)
   '(font-lock-builtin-face ((t (:foreground "magenta"))))                ; 組み込み関数
   '(font-lock-function-name-face ((t (:foreground "green"))))            ; 関数名
   '(font-lock-variable-name-face ((t (:foreground "unspecified-fg"))))   ; 変数名（地色のまま）
   '(font-lock-type-face ((t (:foreground "cyan"))))                      ; 型・クラス
   '(font-lock-constant-face ((t (:foreground "magenta"))))               ; 定数・数値
   '(font-lock-warning-face ((t (:foreground "red" :weight bold))))       ; 警告
   ))
