unit HlpBrowser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, ComCtrls, ToolWin, ImgList;

type
  THtmlHelp = class(TForm)
    HtmlHelpBrowser: TWebBrowser;
    BrowserBar: TToolBar;
    btnBack: TToolButton;
    btnForward: TToolButton;
    BrowserImages: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    HtmlHelpStatus: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure HtmlHelpBrowserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure HtmlHelpBrowserDownloadBegin(Sender: TObject);
    procedure HtmlHelpBrowserDownloadComplete(Sender: TObject);
    procedure HtmlHelpBrowserDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HtmlHelp: THtmlHelp;

implementation

{$R *.DFM}

procedure THtmlHelp.FormShow(Sender: TObject);
var
   HelpPath: string;
begin
   HelpPath := Application.HelpFile;
   HtmlHelpBrowser.Navigate(HelpPath);
   end;

procedure THtmlHelp.btnBackClick(Sender: TObject);
begin
   try
   HtmlHelpBrowser.GoBack;
   except
   end;
   end;

procedure THtmlHelp.btnForwardClick(Sender: TObject);
begin
   try
   HtmlHelpBrowser.GoForward;
   except
   end;
   end;

procedure THtmlHelp.ToolButton1Click(Sender: TObject);
begin
   OnShow(Sender);
   end;

procedure THtmlHelp.HtmlHelpBrowserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
   HtmlHelpStatus.SimpleText := 'Opening ' + URL;
   end;


procedure THtmlHelp.HtmlHelpBrowserDownloadBegin(Sender: TObject);
begin
   HtmlHelpStatus.SimpleText := 'Opening ' + HtmlHelpBrowser.LocationURL;
   end;

procedure THtmlHelp.HtmlHelpBrowserDownloadComplete(Sender: TObject);
begin
   HtmlHelpStatus.SimpleText := 'Rendering ' + HtmlHelpBrowser.LocationURL;
   end;

procedure THtmlHelp.HtmlHelpBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
   HtmlHelpStatus.SimpleText := 'Done ' + HtmlHelpBrowser.LocationURL;
   end;

end.
