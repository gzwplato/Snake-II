unit Hauptprogramm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  TMoveDirection = (up,down,left,right);

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

const
  Delta=10;
var
  Form1: TForm1;
  MoveDirection:TMoveDirection;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key of
    38: //Up Arrow
      MoveDirection := TMoveDirection.up;
    40: //Down Arrow
      MoveDirection := TMoveDirection.down;
    37: //Left Arrow
      MoveDirection := TMoveDirection.left;
    39: //Right Arrow
      MoveDirection := TMoveDirection.right;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    Case MoveDirection of
    TMoveDirection.up:
      Image1.Top := Image1.Top - Delta;
    TMoveDirection.down:
      Image1.Top := Image1.Top + Delta;
    TMoveDirection.left:
      Image1.Left := Image1.Left - Delta;
    TMoveDirection.right:
      Image1.Left := Image1.Left + Delta;
    end;
end;

end.
