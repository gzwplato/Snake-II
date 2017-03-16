unit Hauptprogramm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  TMoveDirection = (up,down,left,right);

  { THauptfenster }

  // Hauptfenster
  THauptfenster = class(TForm)
    HUDScore: TLabel;
    HUDTextScore: TLabel;
    HUDTrenner: TShape;
    Start: TBitBtn;
    Essen: TImage;
    Kopf: TImage;
    GameTick: TTimer;
    procedure StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GameTickTimer(Sender: TObject);
    function Schwanzerstellen:boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

const
  //Bestimmte Abstand zwischen Teleportationen der Schlange,
  //sowie die Groesse der Grafiken
  Delta=25;
var
  Hauptfenster: THauptfenster;
  MoveDirection: TMoveDirection;
  Score:integer=0;                   // Speichert den aktuellen Punktestand
  //Variaben für Snwanz
  Schwanz: array of TImage;   //Speichert die Schwanzelemente
  Schwanzanzahl:integer=0;   //Speichert die Anzahl an Schwanzelementen

implementation

{$R *.lfm}

{ THauptfenster }

function RandomCord(Sender: TImage): boolean;
begin
  //Setzt Objekt an zufällige Koordinaten Auf Bildschirm
  //Berücksichtig HUD
  randomize;
  Sender.Top:= ((random(Hauptfenster.Height - (Hauptfenster.HUDTrenner.Top + Hauptfenster.HUDTrenner.Height)) + (Hauptfenster.HUDTrenner.Top + Hauptfenster.HUDTrenner.Height)) div Delta)* Delta;
  Sender.Left:= (random(Hauptfenster.Height) div Delta)* Delta;
  //(Hauptfenster.HUDTrenner.Top + TShape.HUDTrenner.Height)
end;

procedure THauptfenster.FormCreate(Sender: TObject);
begin
  //Schwanz.SchwanzCreate(Schwanz);
  Hauptfenster.Color:=0;
  //Fenster Mittig auf Bildschirm platzieren
  Hauptfenster.Top:= (Screen.Height - Hauptfenster.Height) div 2;
  Hauptfenster.Left:= (Screen.Width - Hauptfenster.Width) div 2;
end;

procedure THauptfenster.StartClick(Sender: TObject);
begin
  // Groesse von Kopf, Essen und Schwanz an Bewegungsabstand anpassen
  Kopf.Width := Delta;
  Kopf.Height := Delta;
  Essen.Width := Delta;
  Essen.Height := Delta;

  // Kopf, Essen an Zufällige Position platzieren platzieren
  RandomCord(Kopf);
  RandomCord(Essen);

  // Start Knopf ausblenden
  Start.Visible:=False;

  // HUD Einblenden
  HUDTrenner.Visible:=true;
  HUDTextScore.Visible:=true;
  HUDScore.Visible:=true;
  HUDScore.Caption:=inttostr(Score);

  // GameTick starten
  GameTick.Enabled:=True;

  // Kopf und Essen anzeigen
  Kopf.Visible := True;
  Essen.Visible := True;
end;

procedure THauptfenster.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
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

procedure THauptfenster.GameTickTimer(Sender: TObject);
Var
  NewCord: integer;
begin
    Case MoveDirection of
    TMoveDirection.up:                        //Move Snake Up by Delta Pixels
      begin
        NewCord := Kopf.Top - Delta;
        if NewCord < (HUDTrenner.Top + HUDTrenner.Height) then                   //If snake moves out of Window Teleport down
          Kopf.Top := NewCord + Hauptfenster.Height - (HUDTrenner.Top + HUDTrenner.Height)
        else                                  //else just move up
          Kopf.Top := NewCord;
      end;

    TMoveDirection.down:                      //Move Snake Down by Delta Pixels
      begin
        NewCord := Kopf.Top + Delta;
        if NewCord > Hauptfenster.Height - Delta then         //If snake moves out of Window Teleport down
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Top := NewCord - Hauptfenster.Height + (HUDTrenner.Top + HUDTrenner.Height)
        else                                  //else just move down
          Kopf.Top := NewCord;
      end;

    TMoveDirection.left:                      //Move Snake Left by Delta Pixels
      begin
        NewCord := Kopf.Left - Delta;
        if NewCord < 0 then                   //If snake moves out of Window Teleport to right border
          Kopf.Left := NewCord + Hauptfenster.Width
        else                                  //else just move left
          Kopf.Left := NewCord;
      end;

    TMoveDirection.right:                     //Move Snake Right by Delta Pixels
      begin
        NewCord := Kopf.Left + Delta;
        if NewCord > Hauptfenster.Width - Delta then         //If snake moves out of Window Teleport to left border
                                                      // - Delta, da Position an oberer, linker Ecke gemessen wird
          Kopf.Left := NewCord - Hauptfenster.Width
        else                                  //else just move right
          Kopf.Left := NewCord;
      end;
    end;

    // Kollision zwischen Kopf und Essen
    if  (Essen.top  = Kopf.top) and (Essen.left = Kopf.left)
    then
      begin
        Essen.visible:=false;
        Score:= Score +1;

        // Neue Position für Essen
        RandomCord(Essen);
        HUDScore.Caption:=inttostr(Score);
        Essen.visible:=true;

        //Schlange anfügen
        Schwanzerstellen;
    end;
end;

function THauptfenster.Schwanzerstellen: boolean;
begin
  Schwanzanzahl:=Schwanzanzahl+1;
  if Schwanzanzahl>0 then
  SetLength(Schwanz,Schwanzanzahl);    // Array um 1 Platz vergrößern
  Schwanz[Schwanzanzahl]:=TImage.Create(Kopf);     // Schwanzelemnt in neuen Platz einfügen
  with Schwanz[Schwanzanzahl] do
  begin
    Picture.LoadFromFile('Bilder\Schwanz1.png');
    Top:=Kopf.Top;
    Left:=Kopf.Left;
    Width:=Delta;
    Height:=Delta;
    Stretch:=true;
    Enabled:=true;
    Visible:=true;
    Parent:=Hauptfenster;                         //Ordnet Schlangenelement Hauptfenster zu
                                                  //dadurch wird es auch erst angezeigt
  end;
end;

end.

