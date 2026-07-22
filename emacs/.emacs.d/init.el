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
  ;; 背景と文字色は Ghostty から引き継ぐ（Monokai Classic の bg/fg と一致）
  (set-face-background 'default "unspecified-bg")
  (set-face-foreground 'default "unspecified-fg")

  ;; シンタックスハイライトは Monokai Classic の実パレット（Ghostty から
  ;; 取得した hex 値）を直接指定する。
  ;;   ※ Emacs 30 + COLORTERM=truecolor では "blue" 等の色名が端末パレット
  ;;      ではなく X11 の固定色（青＝#0000FF）として 24bit 出力され、暗い
  ;;      背景 #272822 でほぼ見えない。そのため hex 直指定に切り替えている。
  ;;      旧「青」枠の用途（引数・リンク）は Monokai の橙 #fd971f を使う。
  (let ((pink   "#f92672")   ; キーワード・演算子・警告
        (green  "#a6e22e")   ; 関数名
        (yellow "#e6db74")   ; 文字列
        (orange "#fd971f")   ; 引数・リンク（旧「青」の代替）
        (purple "#ae81ff")   ; 定数・数値
        (cyan   "#66d9ef")   ; 型・クラス・組み込み
        (grey   "#6e7066"))  ; コメント
    (custom-set-faces
     `(default ((t (:background "unspecified-bg" :foreground "unspecified-fg"))))
     ;; --- font-lock（シンタックス） ---
     `(font-lock-comment-face ((t (:foreground ,grey))))              ; コメント
     `(font-lock-comment-delimiter-face ((t (:foreground ,grey))))    ; コメント記号 ;; //
     `(font-lock-doc-face ((t (:foreground ,grey))))                  ; ドキュメント文字列
     `(font-lock-string-face ((t (:foreground ,yellow))))             ; 文字列
     `(font-lock-keyword-face ((t (:foreground ,pink))))              ; キーワード (if, for等)
     `(font-lock-operator-face ((t (:foreground ,pink))))             ; 演算子
     `(font-lock-builtin-face ((t (:foreground ,cyan))))              ; 組み込み関数
     `(font-lock-function-name-face ((t (:foreground ,green))))       ; 関数名（定義）
     `(font-lock-function-call-face ((t (:foreground "unspecified-fg")))) ; 関数呼び出し
     `(font-lock-variable-name-face ((t (:foreground "unspecified-fg")))) ; 変数名（地色）
     `(font-lock-variable-use-face ((t (:foreground "unspecified-fg"))))  ; 変数参照
     `(font-lock-type-face ((t (:foreground ,cyan :slant italic))))   ; 型・クラス
     `(font-lock-constant-face ((t (:foreground ,purple))))           ; 定数
     `(font-lock-number-face ((t (:foreground ,purple))))             ; 数値
     `(font-lock-warning-face ((t (:foreground ,pink :weight bold))))  ; 警告
     ;; --- UI 系（旧来「青」で見えづらかった箇所を橙/シアンに） ---
     `(link ((t (:foreground ,orange :underline t))))                 ; ハイパーリンク
     `(minibuffer-prompt ((t (:foreground ,cyan))))                   ; ミニバッファのプロンプト
     )))
