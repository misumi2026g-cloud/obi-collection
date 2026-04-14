# DESIGN_v2.md — アップグレードデザイン仕様

> 方向性: レコードコレクション・音楽アーカイブとしての重厚感  
> ミュージアム／ギャラリー的な洗練、Wu-Tang イエロー（#F5C518）をアクセントカラーに統一

---

## 1. デザインコンセプト

**"Archive Pavilion"** — 希少盤を展示するプライベートミュージアムのような佇まい。  
情報の密度よりも「一枚一枚のアルバムへの敬意」を体現したレイアウト。

- 余白を広く取り、各アルバムが「呼吸」できる空間を設ける
- OBIストリップを想起させるゴールド＋深紅のアクセント
- タイポグラフィは格調高くシンプル、情報の階層をはっきり示す
- カードにhoverエフェクトを加え、インタラクションに質感をもたせる

---

## 2. カラーパレット

### ベース（現行から維持・精緻化）

| 変数名 | 値 | 用途 |
|---|---|---|
| `--black` | `#0A0A0A` | 最深部背景 |
| `--ink` | `#111111` | ボディ背景（純黒より柔らかく） |
| `--surface-0` | `#161616` | カード背景・セクション底面 |
| `--surface-1` | `#1E1E1E` | ヘッダー・モーダル背景 |
| `--surface-2` | `#252525` | hover状態・サブ背景 |
| `--border-subtle` | `#2C2C2C` | 区切り線・グリッドライン |
| `--border-mid` | `#3A3A3A` | カードボーダー通常時 |

### アクセント

| 変数名 | 値 | 用途・根拠 |
|---|---|---|
| `--gold-obi` | `#F5C518` | メインゴールド（Wu-Tang イエロー） |
| `--gold-bright` | `#F9D040` | hover時ハイライト・強調 |
| `--gold-dim` | `#A08000` | ボーダー暗色側・影 |

### テキスト

| 変数名 | 値 | 用途 |
|---|---|---|
| `--text-primary` | `#F0EDE6` | メインテキスト（温かみのあるオフホワイト） |
| `--text-secondary` | `#9A9080` | サブテキスト・メタ情報 |
| `--text-muted` | `#5C5650` | プレースホルダー・非アクティブ |
| `--text-gold` | `#F5C518` | アーティスト名・ラベル強調 |

---

## 3. タイポグラフィ

### フォントファミリー

| 役割 | フォント | 理由 |
|---|---|---|
| サイトタイトル | `'Barlow Condensed', Impact, sans-serif` (weight 800) | Impact系のコンデンス×重量感、メーム連想なく格調あり |
| セクション見出し | `'Oswald', sans-serif` (700) | 現行維持、レコードラベル的な力強さ |
| アーティスト名 | `'Bebas Neue', sans-serif` | 現行維持 |
| 本文・UI | `'Inter', 'Roboto Condensed', sans-serif` | 可読性重視、モダンなサンセリフ |
| カタログ番号・年 | `'Roboto Mono', monospace` | アーカイブデータとしての機械的質感 |

### サイズスケール

```
--text-xs:   0.7rem    /* カタログ番号・バッジ */
--text-sm:   0.85rem   /* メタ情報・UI補助テキスト */
--text-base: 1rem      /* 標準本文 */
--text-md:   1.2rem    /* アルバムタイトル */
--text-lg:   1.5rem    /* アーティスト名（カード内） */
--text-xl:   2.5rem    /* モーダル見出し */
--text-2xl:  3.5rem    /* サイトタイトル */
```

---

## 4. スペーシング（余白を広く）

現行に比べ全体的に1.5〜2倍の余白を確保。

```
--space-1:  0.5rem    /* 極小 */
--space-2:  1rem      /* 小 */
--space-3:  1.5rem    /* 標準 */
--space-4:  2.5rem    /* 中 */
--space-5:  4rem      /* 大（セクション間） */
--space-6:  6rem      /* 特大（ヒーロー余白） */
```

- メインコンテンツ: `padding: 0 clamp(1.5rem, 5vw, 4rem)`
- ヘッダー: `padding: 1.5rem 2rem`（現行の2倍）
- カードグリッド: `gap: 1rem`（現行0.35rem → 3倍）
- max-width: `1440px`

---

## 5. カード・グリッドレイアウト

### グリッドビュー（アップグレード）

```css
grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
gap: 1rem;
```

デスクトップでは minmax を 200px に拡大し、より大きくアルバムアートを表示。

#### カードスタイル

```css
.album-card {
  background: var(--surface-0);
  border: 1px solid var(--border-mid);
  border-radius: 6px;
  overflow: hidden;
  cursor: pointer;
  transition: 
    transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94),
    border-color 0.3s ease,
    box-shadow 0.3s ease;
}
```

#### Hoverエフェクト（グリッドカード）

シンプルなボーダー変化のみ。transform・scale・glowは使わない。

```css
.album-card:hover {
  border-color: var(--gold-obi);
}
```

#### Hoverオーバーレイ（画像上）

※ テキストオーバーレイなし。グラデーション暗幕のみ表示。

```css
.album-image-container::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to bottom,
    transparent 45%,
    rgba(0,0,0,0.88) 100%
  );
  opacity: 0;
  transition: opacity 0.3s ease;
}

.album-card:hover .album-image-container::after {
  opacity: 1;
}
```

### リストビュー（アップグレード）

- サムネイル: `120px × 120px`（現行90px → 拡大）
- カードpadding: `1rem 1.5rem`
- hover: `transform: translateX(4px)` + ゴールドボーダー
- 左端に`3px solid --gold-obi`のアクセントラインを追加（OBI帯のイメージ）

```css
.list-view .album-card {
  border-left: 3px solid transparent;
  transition: border-left-color 0.2s ease, transform 0.2s ease, background 0.2s ease;
}
.list-view .album-card:hover {
  border-left-color: var(--gold-obi);
  transform: translateX(4px);
  background: var(--surface-2);
}
```

---

## 6. ヘッダー

```css
.site-header {
  background: var(--surface-1);
  border-bottom: 1px solid var(--border-subtle);
  /* 下部に細いゴールドライン */
  box-shadow: 
    0 1px 0 var(--gold-dim),
    0 4px 20px rgba(0,0,0,0.5);
  padding: 1.5rem 2rem 1rem;
}
```

### サイトタイトル

```css
.site-title {
  font-family: 'Barlow Condensed', Impact, sans-serif;
  font-size: clamp(1.8rem, 4vw, 3.5rem);
  font-weight: 800;
  letter-spacing: 0.15em;
  color: var(--gold-obi);    /* #F5C518 Wu-Tang イエロー */
  text-transform: uppercase;
}

/* "·" 区切りをゴールドに */
.site-title .dot {
  color: var(--gold-obi);
}

/* ディスクアイコンは除去 or 静止状態に変更 */
```

---

## 7. アルファベットインデックスバー

```css
#alphaIndexBar {
  background: var(--ink);
  border-bottom: 1px solid var(--border-subtle);
  padding: 0.75rem 2rem;
}

.alpha-btn {
  font-family: 'Oswald', sans-serif;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  padding: 0.3rem 0.6rem;
  border: 1px solid var(--border-mid);
  color: var(--text-secondary);
  border-radius: 2px;
  transition: all 0.15s ease;
}

.alpha-btn:hover:not(:disabled) {
  border-color: var(--gold-obi);
  color: var(--gold-obi);
  background: rgba(245,197,24,0.08);
}

.alpha-btn.active {
  background: var(--gold-obi);
  color: var(--black);
  border-color: var(--gold-obi);
}
```

---

## 8. コントロールUI

- paddingを`0.5rem 0.75rem`に拡大（現行0.35rem）
- border-radiusを`4px`に統一
- セレクトボックス: ゴールドボーダーを`--gold-dim`に落とし、フォーカス時に`--gold-obi`へ遷移
- 検索バー: ボーダー色`--border-mid` → focus時`--gold-obi`

```css
.compact-search {
  border: 1px solid var(--border-mid);
  background: var(--surface-0);
  color: var(--text-primary);
  padding: 0.5rem 0.75rem;
  font-size: 0.9rem;
  border-radius: 4px;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.compact-search:focus {
  border-color: var(--gold-obi);
  box-shadow: 0 0 0 2px rgba(245,197,24,0.12);
  outline: none;
}
```

---

## 9. モーダル

```css
.modal-content {
  background: var(--surface-1);
  border: 1px solid var(--border-mid);
  border-top: 3px solid var(--gold-obi);  /* OBIストリップ風トップライン */
  border-radius: 8px;
  box-shadow: 
    0 24px 64px rgba(0,0,0,0.8),
    0 0 0 1px rgba(245,197,24,0.1);
  animation: modalRise 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

@keyframes modalRise {
  from { opacity: 0; transform: translateY(24px) scale(0.98); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* 区切り線をゴールドに */
.modal-album-header {
  border-bottom: 1px solid var(--gold-dim);
}

/* カタログ番号などのラベルをゴールドアクセントに */
.detail-label {
  color: var(--gold-obi);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
}
```

---

## 10. アクションボタン

OBIストリップの色を活用した2トーン構成。

```css
/* プライマリ（Apple Music / YouTube） */
.action-btn.primary {
  background: var(--gold-obi);
  border-color: var(--gold-obi);
  color: var(--black);
}
.action-btn.primary:hover {
  background: var(--gold-bright);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(245,197,24,0.3);
}

/* セカンダリ（Discogs / Genius 等） */
.action-btn.secondary {
  background: transparent;
  border: 1px solid var(--border-mid);
  color: var(--text-secondary);
}
.action-btn.secondary:hover {
  border-color: var(--gold-dim);
  color: var(--gold-obi);
  background: rgba(245,197,24,0.06);
  transform: translateY(-2px);
}
```

---

## 11. スクロールバー

```css
::-webkit-scrollbar { width: 6px; }  /* 細く上品に */
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { 
  background: var(--gold-dim); 
  border-radius: 3px; 
}
::-webkit-scrollbar-thumb:hover { background: var(--gold-obi); }
```

---

## 12. 追加の装飾要素（ギャラリー感）

### OBIストリップ装飾ライン

カードグリッドの上部、またはセクション見出しに細いゴールドラインを入れる。

```css
.section-divider {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin: 2.5rem 0;
}
.section-divider::before,
.section-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: linear-gradient(to right, transparent, var(--border-mid));
}
.section-divider::before {
  background: linear-gradient(to right, var(--gold-dim), var(--border-mid));
  max-width: 4px;  /* ゴールドの短いアクセント */
}
```

### カタログ番号バッジ（リストビュー）

```css
.catalog-badge {
  font-family: 'Roboto Mono', monospace;
  font-size: 0.65rem;
  color: var(--text-muted);
  letter-spacing: 0.05em;
  padding: 0.1rem 0.4rem;
  border: 1px solid var(--border-subtle);
  border-radius: 2px;
}
```

---

## 13. アニメーション方針

- easing: `cubic-bezier(0.25, 0.46, 0.45, 0.94)`（ease-out-quartに近い、滑らかな減速）
- duration: hover系`0.25s`、モーダル`0.4s`、フェード`0.3s`
- **スピン廃止**: タイトルのディスクアイコン回転は停止し、静的なシンボルとして扱う
- カードhoverの`transform`にGPUヒントとして`will-change: transform`を付与

---

## 14. レスポンシブ

```
~480px:  grid minmax(100px, 1fr) → 3カラム固定、余白縮小
481-768px: grid minmax(130px, 1fr)
769-1024px: grid minmax(160px, 1fr)
1025px+: grid minmax(200px, 1fr)
```

---

## 15. 現行からの主な変更サマリー

| 項目 | 現行 | v2 |
|---|---|---|
| グリッドgap | `0.35rem` | `1rem` |
| カードminサイズ | `100px` | `160px`（デスクトップ`200px`） |
| カードhover | なし | ボーダー色変化のみ（シンプル） |
| サイトタイトルフォント | Bebas Neue（ゴシック） | Cormorant Garamond（セリフ） |
| ゴールドトーン | `#FFD700`（鮮やか） | `#C9A84C`（落ち着いたOBI金） |
| 赤アクセント | なし | なし（ゴールド `#F5C518` に統一） |
| ヘッダーpadding | `0.75rem 1rem` | `1.5rem 2rem` |
| メインコンテンツpadding | `0 1.5rem` | `0 clamp(1.5rem, 5vw, 4rem)` |
| スクロールバー幅 | `12px` | `6px` |
| モーダルアニメ | `translateY(-50px)` | `scale(0.98) + translateY(24px)` cubic |
| リストカードhover | 色変化のみ | `translateX(4px)` + ゴールド左ボーダー |
