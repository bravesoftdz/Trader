unit fmViewImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, myRzPanel;

type
  TFormViewImage = class(TForm)
    MyRzPanel9: TMyRzPanel;
    ImagePic: TImage;
    procedure ImagePicClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormViewImage: TFormViewImage;

implementation

{$R *.dfm}

procedure TFormViewImage.ImagePicClick(Sender: TObject);
begin
  self.Close;
end;

end.
