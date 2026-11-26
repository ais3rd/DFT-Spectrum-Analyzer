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
  // t_sec   : waktu dalam detik
  // X       : frekuensi sinyal sinus pertama (Hz)
  // Y       : frekuensi sinyal sinus kedua (Hz)
  // Re_Xk   : bagian real dari X[k]
  // Im_Xk   : bagian imajiner dari X[k]
  // Mag     : magnitudo |X[k]|
  t_sec, X, Y, Re_Xk, Im_Xk, Mag: double;
  // i : indeks sampel n
  // k : indeks bin frekuensi
  // N : jumlah sampel
  i, k, N: integer;

implementation

{$R *.dfm}

const
  // filetext.txt milik proyek BukaFileLaluPlot, relatif terhadap DFT\Win32\Debug\DFT.exe
  ECGFile = '..\..\..\BukaFileLaluPlot\filetext.txt';

procedure TForm1.GetSignal;
var
  // Lines   : isi file EKG, satu baris per sampel
  // sep_pos : posisi pemisah ';' di dalam baris
  Lines: TStringList;
  sep_pos: integer;
begin
  case RadioGroup1.ItemIndex of
    0:
      begin
        N := 256;
        setlength(SignalData, N);

        X := 5.0;
        Y := 20.0;

        for i:= 0 to N - 1 do
          begin
            // Konversi sampel ke waktu: t = n / N
            t_sec := i / N;
            // Penjumlahan dua sinyal sinus: x(t) = sin(2 * pi * X * t) + sin(2 * pi * Y * t)
            SignalData[i] := sin(2 * pi * X * t_sec) + sin(2 * pi * Y * t_sec);
          end;
      end;

    1:
      begin
        // EKG dari file: tiap baris "waktu;nilai", ambil nilai setelah ';'
        Lines := TStringList.Create;
        try
          Lines.LoadFromFile(ExpandFileName(ExtractFilePath(ParamStr(0)) + ECGFile));
          N := Lines.Count;
          setlength(SignalData, N);
          for i:= 0 to N - 1 do
            begin
              sep_pos := Pos(';', Lines[i]);
              SignalData[i] := StrToFloat(Copy(Lines[i], sep_pos + 1, Length(Lines[i])));
            end;
        finally
          Lines.Free;
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

