---
title: "Guide4me"
date: 2021-09-17T15:41:19+08:00
draft: true
---

# Filter research to do
This is a brief note for me, for how to go with filtering.

## Talk with Show-Bo 2021-09-17
keywords:
- matlab: `filtfilt`, `fdatool`
- methods: Butterworth, IIR, FIR

#### 關於Resample:
- Resample前需要低通濾波，不然會造成全新訊號。
  - 混疊效應：像是日光燈(60Hz)下的輪子轉動會看到輪子逆轉、圖片未經濾波縮小會看到柵欄。
- 移動平均算是一種濾波，但會造成很多扭曲。

#### 關於 matlab 的`filtfilt`
- 為 Zero-phase digital filtering。由於往一個資料的紀錄方向(例如順著時間軸)進行濾波會產生相位位移，Zero-phase digital filtering 的方法是兩個方向(往前與往後)濾波各做一次，理論上可以抵消相位位移。
- 推薦
- 決定Transfer function (a,b係數):濾波器基本上是分子/分母各一個多項式。設計濾波器即在決定這兩個多項式的係數。 

#### 關於資料填值：
- 待濾波的資料不能有任何缺失值
- 缺失值可以填零；填零可視為一種方波。
- 將方波訊號轉換至頻率域，會看到強度隨頻率減小的不連續峰值，代表方波為無限多個sin/cos基頻所組成
- 濾完波轉回時間域後，把原本填零(或填方波)的那個區塊再變回缺失值。# TODO: 試試將訊號波特定區段改方波高通濾波，還原回時間域，看原本方波的部分變成怎樣(應該會變成組成方波剩下的低頻sin波)。
- 填零值也是白噪音: 含所有頻率但強度皆為零 # TODO: 前項也可試試訊號波特定區段改白噪音。


#### 關於`fdatool`
`fdatool`
- 在 matlab command window 輸入 `fdatool` 開啟濾波器設計界面。
- 你可以在上方小按鈕 Filter Specification 設計濾波器，決定截止頻率(Fstop)與 filter order。例如一個低通濾波器，設定Fstop=10kHz，filter order = 3，則訊號於頻率域>10kHz時強度會-3dB。

IIR:
- 濾波會與先前的資料相依，不斷影響後來的資料濾波
- 不穩定，但符合許多真實情境(例如持續記錄的溫度)
- 一般使用推薦Butterworth法，簡單確實好解釋。

FIR:
- 濾波不與先前的資料相依；是數位濾波
- 穩定。



