# DFT Spectrum Analyzer

A Delphi VCL app that implements the **Discrete Fourier Transform** from scratch and shows the magnitude spectrum of a test signal and of a recorded ECG.

## Signals
1. **X+Y**: two summed sines, `x(t) = sin(2π·5t) + sin(2π·20t)`, with N = 256 samples
2. **ECG**: loaded from `filetext.txt` in the [BukaFileLaluPlot / Signal-File-Plotter](https://github.com/ais3rd/Signal-File-Plotter) project. Each line is `time;value` and the value after `;` is used. N equals the number of lines (5000 samples, 10 s at 500 Hz).

The app looks for the file at `..\..\..\BukaFileLaluPlot\filetext.txt` relative to `DFT.exe`, so keep both project folders side by side:
```
Delphi\
├── BukaFileLaluPlot\filetext.txt
└── DFT\Win32\Debug\DFT.exe
```

## DFT
```
X[k] = Σ x[n] · e^(-j·2π·k·n / N)

Re{X[k]} =  Σ x[n] · cos(2π·k·n / N)
Im{X[k]} = -Σ x[n] · sin(2π·k·n / N)
|X[k]|   = √(Re² + Im²) / N        (k = 0, DC)
|X[k]|   = √(Re² + Im²) / (N/2)    (k > 0)
```
The spectrum is plotted for `k = 0 … N/2 − 1` as a bar chart. For the ECG file, bin `k` is `k · fs / N = k · 0.1 Hz`.

> The ECG values use a decimal comma (`-0,115`), so `StrToFloat` needs a comma-decimal Windows locale (e.g. Indonesian).

## Usage
1. Choose a signal in the **Signals** group: `X+Y` or `ECG`
2. Click **Plot** to plot it in the time domain
3. Click **DFT** to plot its magnitude spectrum

## Build
Open `DFT.dproj` in Delphi (RAD Studio, Community Edition works) and run it. It needs the VCL and TeeChart.

## License
Released under the [MIT License](LICENSE).
