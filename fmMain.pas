unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, WMPLib_TLB, ExtCtrls, RzPanel, RzTabs, jpeg, myRzPanel,
  StdCtrls, ComCtrls, RzEdit, RzCommon, msxml, ComObj, ActiveX;

type
  TFormMain = class(TForm)
    RzPanel2: TRzPanel;
    Image1: TImage;
    MyRzPanel1: TMyRzPanel;
    RzPanelVideo: TRzPanel;
    RzPageControlMain: TRzPageControl;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    videoNodelist: IXMLDOMNodeList;
    videoNode: IXMLDOMNode;
    configDOM: IXMLDOMDocument;
    procedure onPlayStatusChange(Sender: TObject; newState: Integer);
    function CreateXMLDoc(async: boolean = false; stats: boolean = false):IXMLDOMDocument;
    procedure initMainPages;
    procedure playVideo;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  Player: TWindowsMediaPlayer;


implementation

uses fmViewImage;
{$R *.dfm}

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  player.Free;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  self.configDOM:=self.CreateXMLDoc(true,false);
  self.configDOM.load(ExtractFilePath(Application.ExeName) + 'config.xml');
  videoNodelist := self.configDOM.documentElement.selectNodes('//title//file');
  if (videoNodelist <> nil) and (videoNodelist.length > 0) then begin
    videoNode:=videoNodelist.item[0];
  end;

  if videoNode<>nil then begin
    self.playVideo;
  end;

  initMainPages;
end;

procedure TFormMain.onPlayStatusChange(Sender: TObject; newState: Integer);
begin
  {
  222.  wmppsUndefined = $00000000;
  223.  wmppsStopped = $00000001;
  224.  wmppsPaused = $00000002;
  225.  wmppsPlaying = $00000003;
  226.  wmppsScanForward = $00000004;
  227.  wmppsScanReverse = $00000005;
  228.  wmppsBuffering = $00000006;
  229.  wmppsWaiting = $00000007;
  230.  wmppsMediaEnded = $00000008;
  231.  wmppsTransitioning = $00000009;
  232.  wmppsReady = $0000000A;
  233.  wmppsReconnecting = $0000000B;
  234.  wmppsLast = $0000000C;
  }
  if newState=1  then begin
    if videoNode.nextSibling<>nil then begin
      videoNode:=videoNode.nextSibling;
    end else begin
      videoNode:=videoNodeList.item[0];
    end;
    if videoNodeList.length=1 then begin
      player.controls.play;
    end else begin
      self.playVideo;
    end;
  end;
end;

function TFormMain.CreateXMLDoc(async: boolean = false; stats: boolean = false):
  IXMLDOMDocument;
var
  dom: IXMLDomDocument;
begin
  dom := CreateComObject(CLASS_DOMDocument) as IXMLDOMDocument;
  //dom := CreateDOMDocument;
  dom.async := async;
  dom.validateOnParse := stats;
  dom.resolveExternals := stats;
  Variant(dom).setProperty('SelectionLanguage', 'XPath');
  Result := dom;
end;

procedure TFormMain.initMainPages;
var
  pNodeList:IXMLDOMNodelist;
  pNode:IXMLDOMNode;
  tab:TRzTabSheet;
  vis,tit,bgf:string;
  i:integer;
  img:TImage;
begin
  pNodeList := self.configDOM.documentElement.selectNodes('//pagecontrol//page');
  if (pNodeList <> nil) and (pNodeList.length > 0) then begin
    for i := 0 to pNodeList.length - 1 do begin
      pNode:=pNodeList.item[i];
      vis:=pNode.attributes.getNamedItem('visible').nodeValue;
      if vis='0' then
        continue;

      tit:=pNode.attributes.getNamedItem('title').nodeValue;
      bgf:=pNode.attributes.getNamedItem('bgfilename').nodeValue;

      tab:=TRzTabSheet.Create(self.RzPageControlMain);
      tab.PageControl:=self.RzPageControlMain;
      tab.Caption:=tit;

      img:=TImage.Create(self);
      img.Parent:=tab;
      img.Align:=alClient;
      img.Stretch:=true;
      if FileExists(bgf) then
        img.Picture.LoadFromFile(bgf);
    end;
  end;

  self.RzPageControlMain.ActivePageIndex:=0;
end;

procedure TFormMain.playVideo;
var
  vFile: String;
begin
  if player<>nil then begin
   player.close;
   player.Free;
  end;

  player := TWindowsMediaPlayer.Create(Self);
  player.Visible:=false;
  player.Parent := self.RzPanelVideo;
  player.Align := alClient;
  player.Visible := True;
  player.Settings.AutoStart := true;
  player.uiMode := 'none';
  player.enableContextMenu := false;
  player.settings.volume := 100;
  player.fullScreen:=false;
  player.windowlessVideo:=true;
  player.stretchToFit := true;
  player.OnPlayStateChange := onPlayStatusChange;

  vFile := videoNode.attributes.getNamedItem('filename').nodeValue;
  player.URL:=vFile;
  player.Controls.play;
  player.Visible:=true;
end;

end.
