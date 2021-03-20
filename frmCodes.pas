unit frmCodes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.NetEncoding;

type
  TForm1 = class(TForm)
    codificar: TButton;
    descodificar: TButton;
    procedure codificarClick(Sender: TObject);
    procedure descodificarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Se genera el archivo con la codificación en base 64 del PDF elegido
procedure TForm1.codificarClick(Sender: TObject);
var
  inStream, outStream: TStream;
  oFile: TOpenDialog;
  ruta: string;
begin
  oFile:= TOpenDialog.Create(nil);  // Iniciamos el dialog para elegir el archivo origen
  try        
    oFile.Filter:= 'pdf|*.pdf';
    oFile.InitialDir:= 'C:\';
    oFile.Execute;    
    ruta:= ExtractFilePath(oFile.FileName); // Guardamos la ruta para usarla como destino del archivo con codificación
    inStream := TFileStream.Create(oFile.FileName, fmOpenRead); // Iniciamos el stream de origen
    outStream := TFileStream.Create(ruta + 'encodeB64PDF.txt', fmCreate); // Iniciamos el stream de destino
      try
        TNetEncoding.Base64.Encode(inStream, outStream);  // Codificamos a base 64 bajo UTF-8
      finally
        ShowMessage('Archivo codificado guardado en ' + ruta);
        outStream.Free;
        inStream.Free;
      end;
  finally
    oFile.Free;
  end;
end;

// Se genera archivo PDF con la codificación base 64 del archivo TXT
procedure TForm1.descodificarClick(Sender: TObject);
var
  inStream, outStream: TStream;
  oFile: TOpenDialog;
  ruta: string;
begin
  oFile:= TOpenDialog.Create(nil);  // Iniciamos el dialog para elegir el archivo origen
  try        
    oFile.Filter:= 'txt|*.txt';
    oFile.InitialDir:= 'C:\';
    oFile.Execute; 
    ruta:= ExtractFilePath(oFile.FileName); // Guardamos la ruta para usarla como destino del archivo descodificado
    inStream := TFileStream.Create(oFile.FileName, fmOpenRead); // Iniciamos el stream de origen       
    outStream := TFileStream.Create(ruta + 'decodeB64PDF.pdf', fmCreate); // Iniciamos el stream de destino
    try
      TNetEncoding.Base64.Decode(inStream, outStream);  // Descodificamos el archivo PDF desde el TXT con el codigo en base 64
    finally
      ShowMessage('Archivo descodificado guardado en ' + ruta);
      outStream.Free;
      inStream.Free;
    end;
  finally               
    oFile.Free;
  end;
end;

end.
