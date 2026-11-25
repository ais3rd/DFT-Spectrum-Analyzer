unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    RadioGroup1: TRadioGroup;
    Chart1: TChart;
    Series1: TLineSeries;
    Chart2: TChart;
    Series2: TBarSeries;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    procedure GetSignal;
  public
  end;

var
  Form1: TForm1;
  // SignalData : sampel sinyal x[n]
  SignalData: array of double;
  // t       : waktu dalam satu detak EKG (0 sampai 1)
  // t_sec   : waktu dalam detik
  // d       : jarak Gaussian (t - mu) / sigma
  // X       : frekuensi sinyal sinus pertama (Hz)
  // Y       : frekuensi sinyal sinus kedua (Hz)
  // Noise50 : nilai noise 50 Hz
  // Noise80 : nilai noise 80 Hz
  // Re_Xk   : bagian real dari X[k]
  // Im_Xk   : bagian imajiner dari X[k]
  // Mag     : magnitudo |X[k]|
  t, t_sec, d, X, Y, Noise50, Noise80, Re_Xk, Im_Xk, Mag: double;
  // i : indeks sampel n
  // k : indeks bin frekuensi
  // N : jumlah sampel
  i, k, N: integer;

implementation

{$R *.dfm}

procedure TForm1.GetSignal;
begin
  N := 256;
  setlength(SignalData, N);

  X := 5.0;
  Y := 20.0;

  for i:= 0 to N - 1 do
    begin
      // Konversi sampel ke waktu: t = n / N
      t_sec := i / N;

      case RadioGroup1.ItemIndex of
        0:
          begin
            // Penjumlahan dua sinyal sinus: x(t) = sin(2 * pi * X * t) + sin(2 * pi * Y * t)
            SignalData[i] := sin(2 * pi * X * t_sec) + sin(2 * pi * Y * t_sec);
          end;

        1:
          begin
            // EKG sintetis: penjumlahan pulsa Gaussian, A * exp(-((t - mu) / sigma)^2)
            // Waktu periodik (2 detak): t = (n mod (N/2)) / (N/2)
            t := (i mod (N div 2)) / (N / 2);
            d := (t - 0.20) / 0.03; SignalData[i] := 0.15 * exp(-d * d);                   // Gelombang P
            d := (t - 0.35) / 0.01; SignalData[i] := SignalData[i] - 0.15 * exp(-d * d);   // Gelombang Q
            d := (t - 0.38) / 0.015; SignalData[i] := SignalData[i] + 1.00 * exp(-d * d);  // Gelombang R
            d := (t - 0.41) / 0.01; SignalData[i] := SignalData[i] - 0.25 * exp(-d * d);   // Gelombang S
            d := (t - 0.65) / 0.05; SignalData[i] := SignalData[i] + 0.30 * exp(-d * d);   // Gelombang T
          end;

        2:
          begin
            // EKG sintetis: penjumlahan pulsa Gaussian, A * exp(-((t - mu) / sigma)^2)
            // Waktu periodik (2 detak): t = (n mod (N/2)) / (N/2)
            t := (i mod (N div 2)) / (N / 2);
            d := (t - 0.20) / 0.03; SignalData[i] := 0.15 * exp(-d * d);                   // Gelombang P
            d := (t - 0.35) / 0.01; SignalData[i] := SignalData[i] - 0.15 * exp(-d * d);   // Gelombang Q
            d := (t - 0.38) / 0.015; SignalData[i] := SignalData[i] + 1.00 * exp(-d * d);  // Gelombang R
            d := (t - 0.41) / 0.01; SignalData[i] := SignalData[i] - 0.25 * exp(-d * d);   // Gelombang S
            d := (t - 0.65) / 0.05; SignalData[i] := SignalData[i] + 0.30 * exp(-d * d);   // Gelombang T

            // Noise sinusoidal: A * sin(2 * pi * f * t), pada 50 Hz (jala-jala listrik) dan 80 Hz
            Noise50 := 0.20 * sin(2 * pi * 50.0 * t_sec);
            Noise80 := 0.15 * sin(2 * pi * 80.0 * t_sec);
            SignalData[i] := SignalData[i] + Noise50 + Noise80;
          end;
      end;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  GetSignal;
  Series1.clear;
  for i:= 0 to N - 1 do
    Series1.addxy(i, SignalData[i]);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  GetSignal;
  Series2.clear;

  // Transformasi Fourier Diskrit (DFT): X[k] = sum x[n] * e^(-j * 2 * pi * k * n / N)
  for k:= 0 to (N div 2) - 1 do
    begin
      Re_Xk := 0;
      Im_Xk := 0;
      for i:= 0 to N - 1 do
        begin
          // Bagian real: Re{X[k]} = sum x[n] * cos(2 * pi * k * n / N)
          Re_Xk := Re_Xk + SignalData[i] * cos((2 * pi * k * i) / N);
          // Bagian imajiner: Im{X[k]} = -sum x[n] * sin(2 * pi * k * n / N)
          Im_Xk := Im_Xk - SignalData[i] * sin((2 * pi * k * i) / N);
        end;

      // Spektrum magnitudo: |X[k]| = sqrt(Re^2 + Im^2), dibagi N untuk k = 0 (DC), selain itu dibagi N/2
      if k = 0 then
        Mag := sqrt(sqr(Re_Xk) + sqr(Im_Xk)) / N
      else
        Mag := sqrt(sqr(Re_Xk) + sqr(Im_Xk)) / (N / 2);

      Series2.addxy(k, Mag);
    end;
end;

end.

