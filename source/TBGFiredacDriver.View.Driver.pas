unit TBGFiredacDriver.View.Driver;

interface

uses
  TBGConnection.Model.Interfaces, System.Classes, TBGConnection.Model.Conexao.Parametros,
  FireDAC.Comp.Client, System.Generics.Collections, FireDAC.DApt,
  TBGConnection.Model.DataSet.Interfaces;

Type
  TBGFiredacDriverConexao = class(TComponent, iDriver)
  private
    FFConnection: TFDConnection;
    FiConexao : iConexao;
    FiQuery : TList<iQuery>;
    FLimitCacheRegister : Integer;
    FProxy : iDriverProxy;
    procedure SetFConnection(const Value: TFDConnection);
    function GetLimitCache: Integer;
    procedure SetLimitCache(const Value: Integer);
  protected
    FParametros : iConexaoParametros;
    function Conexao : iConexao;
    function Query : iQuery;
    function Cache : iDriverProxy;
    function DataSet : iDataSet;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    class function New : iDriver;
    function ThisAs: TObject;
    function Conectar : iConexao;
    function Parametros: iConexaoParametros;
    function LimitCacheRegister(Value : Integer) : iDriver;
  published
    property FConnection : TFDConnection read FFConnection write SetFConnection;
    property LimitCache : Integer read GetLimitCache write SetLimitCache;
  end;

procedure Register;

implementation


uses
  TBGFiredacDriver.Model.Conexao, TBGFiredacDriver.Model.Query,
  System.SysUtils, TBGFiredacDriver.Model.DataSet,
  TBGConnection.Model.DataSet.Proxy;

{ TBGFiredacDriverConexao }

function TBGFiredacDriverConexao.Cache: iDriverProxy;
begin
  if not Assigned(FProxy) then
    FProxy := TTBGConnectionModelProxy.New(FLimitCacheRegister, Self);

  Result := FProxy;
end;

function TBGFiredacDriverConexao.Conectar: iConexao;
begin

end;

function TBGFiredacDriverConexao.GetLimitCache: Integer;
begin
  Result := FLimitCacheRegister;
end;

function TBGFiredacDriverConexao.LimitCacheRegister(Value: Integer): iDriver;
begin
  Result := Self;
  FLimitCacheRegister := Value;
end;

function TBGFiredacDriverConexao.Conexao: iConexao;
begin
  if not Assigned(FiConexao) then
    FiConexao := TFiredacDriverModelConexao.New(FFConnection, FLimitCacheRegister, Self);

  Result := FiConexao;
end;

constructor TBGFiredacDriverConexao.Create;
begin
  inherited Create(nil);
  FiQuery := TList<iQuery>.Create;
end;

function TBGFiredacDriverConexao.DataSet: iDataSet;
begin
  if not Assigned(FProxy) then
    FProxy := TTBGConnectionModelProxy.New(FLimitCacheRegister, Self);

  Result := TConnectionModelFiredacDataSet.New(FProxy.ObserverList);
end;

destructor TBGFiredacDriverConexao.Destroy;
begin
  FreeAndNil(FiQuery);
  inherited;
end;

class function TBGFiredacDriverConexao.New: iDriver;
begin
  Result := Self.Create;
end;

function TBGFiredacDriverConexao.Parametros: iConexaoParametros;
begin
  Result := FParametros;
end;


function TBGFiredacDriverConexao.Query: iQuery;
begin
  if Not Assigned(FiQuery) then
    FiQuery := TList<iQuery>.Create;

  if Not Assigned(FiConexao) then
    FiConexao := TFiredacDriverModelConexao.New(FFConnection, FLimitCacheRegister, Self);

  FiQuery.Add(TFiredacModelQuery.New(FFConnection, Self));
  Result := FiQuery[FiQuery.Count-1];
end;

procedure TBGFiredacDriverConexao.SetFConnection(const Value: TFDConnection);
begin
  FFConnection := Value;
end;

procedure TBGFiredacDriverConexao.SetLimitCache(const Value: Integer);
begin
  FLimitCacheRegister := Value;
end;

function TBGFiredacDriverConexao.ThisAs: TObject;
begin
  Result := Self;
end;

procedure Register;
begin
  RegisterComponents('TBGAbstractConnection', [TBGFiredacDriverConexao]);
end;


end.
