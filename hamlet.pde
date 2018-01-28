import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

int sysclock = 0;

final int WINDOW_SIZE = 256;

final int TILE_SIZE = WINDOW_SIZE/16;
final int TILE_DELAY = 32;
final int TEXT_DELAY = 3;

String setting = "";

ArrayList<Mob> register = new ArrayList<Mob>();
ArrayList<Font> fontList = new ArrayList<Font>();
ArrayList<Arras> curtains = new ArrayList<Arras>();

Director director;
Background background;
SoundHandler soundHandler;
TitleScreen titleScreen;

PImage dialogueBg;
PImage messageBg;
PImage statcardBg;
PImage fightmessageBg;

int buttonPressed = 0;

boolean fighting = false;

int cameraX;
int cameraY;

color skybox;

boolean shown = false;

boolean automatic = true;

void settings()
{
    size(WINDOW_SIZE, WINDOW_SIZE-TILE_SIZE);
}

void setup()
{
    frameRate(60);

    cameraX = 0;
    cameraY = 0;
    skybox = color(255, 255, 255, 0);

    director = new Director();
    background = new Background();
    soundHandler = new SoundHandler(this);
    titleScreen = null;

    getFilterList();

    dialogueBg = loadImage("./data/images/dialogue.png");
    messageBg = loadImage("./data/images/message.png");
    statcardBg = loadImage("./data/images/statcard.png");
    fightmessageBg = loadImage("./data/images/fightmessage.png");

    fontList.add(new Font("stdtext.png"));

    soundHandler.loadTalkSound("mediumsquare.wav");
    soundHandler.loadTalkSound("lowsquare.wav");
    soundHandler.loadTalkSound("highsquare.wav");

    noStroke();

    director.fileEntry("init");
}

void draw()
{
    sysclock++;

    background(0, 0, 0);

    if (titleScreen != null)
        titleScreen.show();

    if (!fighting && shown)
    {
        /*for (int x = 0; x < 256/TILE_SIZE; x++)
        {
            line(x*TILE_SIZE, 0, x*TILE_SIZE, 240);
        }
        for (int y = 0; y < 240/TILE_SIZE; y++)
        {
            line(0, y*TILE_SIZE, 256, y*TILE_SIZE);
        }*/
        //drawing a grid

        background.show();

        for (int r = 0; r < register.size(); r++)
        {
            register.get(r).act();
        }
        for (Arras a : curtains)
        {
            a.show();
        }
    }

    fill(skybox);
    rect(0, 0, width, height);

    director.run();

    if (buttonPressed > 0)
    {
        buttonPressed -= 1;
    }
}

void keyPressed()
{
    buttonPressed = 5;
}

int systemClock()
{
    return sysclock;
}

boolean filtering = false;
ArrayList<String> filteredWords = new ArrayList<String>();
ArrayList<String> newWords = new ArrayList<String>();

void getFilterList()
{
    BufferedReader reader = createReader("./data/scripts/wordfilter.txt");

    String line;
    String args[];
    int inc = -1;
    while (true)
    {
        try
        {
            line = reader.readLine();
            inc++;
        }
        catch (IOException e)
        {
            e.printStackTrace();
            line = null;
        }

        if (line == null)
        {
            return;
        }
        else
        {
            args = splitTokens(line, "$");
            filteredWords.add(args[0]);
            newWords.add(args[1]);
            //println("FFFFFFFFFFFFFFFFFFFFFFFFFFFFUCK " + filteredWords.get(inc));
        }
    }
}