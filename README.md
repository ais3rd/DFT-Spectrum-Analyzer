# DFT Spectrum Analyzer

A Delphi VCL app that implements the **Discrete Fourier Transform** from scratch and shows the magnitude spectrum of test signals, including a synthetic ECG with power-line noise.

## Signals (N = 256 samples)
1. **Two summed sines**: `x(t) = sin(2π·5t) + sin(2π·20t)`
2. **Synthetic ECG**: two heartbeats, each built from Gaussian pulses for the P, Q, R, S and T waves:
   ```
   A · exp(-((t - μ) / σ)²)
   ```
3. **Synthetic ECG with noise**: the ECG plus 50 Hz power-line noise and 80 Hz noise

## DFT
```
X[k] = Σ x[n] · e^(-j·2π·k·n / N)

Re{X[k]} =  Σ x[n] · cos(2π·k·n / N)
Im{X[k]} = -Σ x[n] · sin(2π·k·n / N)
|X[k]|   = √(Re² + Im²) / N        (k = 0, DC)
|X[k]|   = √(Re² + Im²) / (N/2)    (k > 0)
```
The spectrum is plotted for `k = 0 … N/2 − 1` as a bar chart.

## Usage
1. Choose a signal in the **Signals** group: `X+Y`, `ECG` or `ECG + Noise`
2. Click **Plot** to plot it in the time domain
3. Click **DFT** to plot its magnitude spectrum

## Build
Open `DFT.dproj` in Delphi (RAD Studio, Community Edition works) and run it. It needs the VCL and TeeChart.

## License
Released under the [MIT License](LICENSE).
