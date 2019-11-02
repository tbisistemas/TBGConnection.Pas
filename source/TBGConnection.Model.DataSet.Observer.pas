﻿unit TBGConnection.Model.DataSet.Observer;

interface

{$ifdef FPC}
  {Necessário para uso do package rtl-generics:->  Generics.Collections}
  {$MODE DELPHI}{$H+}
{$endif}

uses
  {$ifndef FPC}
  System.SysUtils,
  System.Generics.Collections,
  Data.DB,
  {$else}
  SysUtils,
  Generics.Defaults,
  Generics.Helpers,
  Generics.Strings,
  Generics.Collections,
  DB,
  {$endif}
  TBGConnection.Model.Interfaces,
  TBGConnection.Model.DataSet.Interfaces;

Type
  TConnectionModelDataSetObserver = class(TInterfacedObject, ICacheDataSetSubject)
  private
    FLista: TList<ICacheDataSetObserver>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New :ICacheDataSetSubject;
    function AddObserver(Value : ICacheDataSetObserver) : ICacheDataSetSubject;
    function RemoveObserver(Value : ICacheDataSetObserver) : ICacheDataSetSubject;
    function Notify(Value : String) : ICacheDataSetSubject;
    function RemoveAllObservers: ICacheDataSetSubject;
  end;

implementation

{ TConnectionModelDataSetObserver }

function TConnectionModelDataSetObserver.AddObserver(Value : ICacheDataSetObserver) : ICacheDataSetSubject;
begin
  Result := Self;
  FLista.Add(Value);
end;

constructor TConnectionModelDataSetObserver.Create;
begin
  FLista := TList<ICacheDataSetObserver>.Create;
end;

destructor TConnectionModelDataSetObserver.Destroy;
begin
  FreeAndNil(FLista);
  inherited;
end;

class function TConnectionModelDataSetObserver.New: ICacheDataSetSubject;
begin
  Result := Self.Create;
end;

function TConnectionModelDataSetObserver.Notify(Value : String) : ICacheDataSetSubject;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to Pred(FLista.Count) do
    FLista.Items[I].Update(Value)
end;

function TConnectionModelDataSetObserver.RemoveAllObservers: ICacheDataSetSubject;
begin
  Result := Self;
  FLista.Clear;
end;

function TConnectionModelDataSetObserver.RemoveObserver(Value : ICacheDataSetObserver) : ICacheDataSetSubject;
begin
  Result := Self;
  FLista.Remove(Value);
end;

end.
