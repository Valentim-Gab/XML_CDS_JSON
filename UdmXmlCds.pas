unit UdmXmlCds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Xmlxform, DB, DBClient, StdCtrls, uLkJson;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure SelectFile(var FileName: string; const Filter: string);
    function ClientDataSetToJSON(cds: TClientDataSet): TlkJSONobject;
    procedure CreateFile(Text: string);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  JSONObj: TlkJSONobject;

implementation

{$R *.dfm}

procedure TForm1.CreateFile(Text: string);
var
  FileText: TextFile;
begin
  if SaveDialog1.Execute then
  begin
    AssignFile(FileText, SaveDialog1.FileName);
    try
      Rewrite(FileText);
      Write(FileText, Text);
      CloseFile(FileText);
      ShowMessage('Arquivo de texto criado com sucesso.');
    except
      on E: Exception do
        ShowMessage('Ocorreu um erro: ' + E.Message);
    end;
  end;
end;

function TForm1.ClientDataSetToJSON(cds: TClientDataSet): TlkJSONobject;
var
  I: Integer;
  Field: TField;
  JSON: TlkJSONobject;
begin
  JSON := TlkJSONobject.Create;

  if not cds.IsEmpty then
  begin
    cds.First;
    while not cds.Eof do
    begin
      for I := 0 to cds.FieldCount - 1 do
      begin
        Field := cds.Fields[I];
        JSON.Add(Field.FieldName, Field.AsString)
      end;
      cds.Next;
    end;

    Result := JSON;
  end;
end;

procedure TForm1.SelectFile(var FileName: string; const Filter: string);
begin
  OpenDialog1.Filter := Filter;
  if OpenDialog1.Execute then
    FileName := OpenDialog1.FileName
  else
    FileName := '';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  XMLFileName, XTRFileName: string;
  XMLTransform: TXMLTransform;
  I: Integer;
  cdsT: TClientDataSet;
begin
  XMLFileName := '';
  XTRFileName := '';
  SelectFile(XMLFileName, 'Arquivos XML|*.xml');

  if XMLFileName <> '' then
  begin
    SelectFile(XTRFileName, 'Arquivos XTR|*.xtr');

    if XTRFileName <> '' then
    begin
      XMLTransform := TXMLTransform.Create(Self);
      cdsT := TClientDataSet.Create(nil);

      try
        XMLTransform.SourceXmlFile := XMLFileName;
        XMLTransform.TransformationFile := XTRFileName;
        cdsT.XMLData := XMLTransform.Data;

        if not cdsT.IsEmpty then
        begin
          cdsT.First;
          while not cdsT.Eof do
          begin
            for I := 0 to cdsT.FieldCount - 1 do
            begin
              Memo1.Lines.Add(cdsT.Fields[I].FieldName + ' = ' + cdsT.Fields[I].AsString);
            end;
            cdsT.Next;
          end;
          JSONObj := ClientDataSetToJSON(cdsT);
        end;
      finally
        XMLTransform.Free;
        cdsT.Free;
      end;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);      
var
  JSONStr: string;
begin
  if JSONObj <> nil then
  begin
    JSONStr := TlkJSON.GenerateText(JSONObj);
    CreateFile(JSONStr)
  end
  else
  begin
    ShowMessage('Converta um arquivo XML em CDS primeiro');
  end;
end;

end.
