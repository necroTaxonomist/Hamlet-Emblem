class NamedMob extends Mob
{
    Sprite portrait;
    Sprite idle;
    Sprite walkdown;
    Sprite walkside;
    Sprite walkup;

    Sprite battleIdle;
    Sprite battleWalk;
    Sprite battleAttack;
    String attackStyle;

    Font myFont;
    int voice;
    int hp;
    String statfile;

    public NamedMob(String nameIn, int xIn, int yIn, String filename)
    {
        super(nameIn, xIn, yIn);
        myFont = null;
        voice = -1;
        hp = -1;

        battleIdle = null;
        battleWalk = null;
        battleAttack = null;
        attackStyle = null;

        BufferedReader reader = createReader("./data/images/characters/" + filename.substring(0, filename.indexOf("."))
            + "/" + filename);
        String line;

        while (true)
        {
            try
            {
                line = reader.readLine();
            }
            catch (IOException e)
            {
                e.printStackTrace();
                line = null;
            }

            if (line == null)
            {
                break;
            }
            else
            {
                loadInfo(line, filename.substring(0, filename.indexOf(".")));
            }
        }
    }

    private void loadInfo(String line, String folder)
    {
        String[] args = splitTokens(line, "$");
        if (args[0].equals("font"))
        {
            for (Font f : fontList)
            {
                if (f.getFilename().equals(args[1].substring(0, args[1].indexOf("."))))
                {
                    myFont = f;
                    break;
                }
            }
        }
        else if (args[0].equals("stats"))
        {
            statfile = folder + "/" + args[1];
        }
        else if (args[0].equals("attackstyle"))
        {
            attackStyle = args[1];
        }
        else if (args[0].equals("voice"))
        {
            int foundVoice = soundHandler.talkSoundIndex(args[1]);
            if (foundVoice != -1)
                voice = foundVoice;
            else
                voice = soundHandler.loadTalkSound(args[1]);
        }
        else if (args[0].equals("portrait"))
        {
            portrait = loadSprite("characters/" + folder + "/" + args[1].substring(0, args[1].indexOf(".")), 
                args[1].substring(args[1].indexOf(".")), 2);
        }
        else
        {
            Sprite newSprite = loadSprite("characters/" + folder + "/" + args[4].substring(0, args[4].indexOf(".")), 
                args[4].substring(args[4].indexOf(".")), 
                int(args[3]));
            newSprite.xOffset = int(args[1]);
            newSprite.yOffset = int(args[2]);
            if (args[0].equals("idle"))
                idle = newSprite;
            else if (args[0].equals("walkdown"))
                walkdown = newSprite;
            else if (args[0].equals("walkside"))
                walkside = newSprite;
            else if (args[0].equals("walkup"))
                walkup = newSprite;
            else if (args[0].equals("battleidle"))
                battleIdle = newSprite;
            else if (args[0].equals("battlewalk"))
                battleWalk = newSprite;
            else if (args[0].equals("battleattack"))
                battleAttack = newSprite;
        }
    }

    public void drawSelf()
    {
        if (stopped())
        {
            int s = 3;
            int l = idle.animLength();

            int n = (systemClock()/8) % (2*l + 2*s - 4);
            int f;

            if (n < s - 1)
                f = 0;
            else if (n >= s - 1 && n < s + l - 1)
                f = n - s + 1;
            else if (n >= s + l - 1 && n < 2*s + l - 2)
                f = l -1;
            else if (n >= 2*s + l - 2)
                f = 2*l - n + 2*s - 4;
            else
                f = 0;

            sprite(idle, f, (int)x - idle.xOffset - cameraX, (int)y - idle.yOffset - cameraY);
            //println(systemClock() + " " + n + " " + idle.animLength());
        }
        else
        {
            if (path.equals("entervert"))
            {
                if (abs(x - destX*TILE_SIZE) > speed)
                {
                    if (x > destX*TILE_SIZE)
                    {
                        //fill(color(255,0,0));
                        //rect((int)x - cameraX,(int)y - cameraY,TILE_SIZE,TILE_SIZE); //DRAW LEFT
                        spriteBackwards(walkside, (systemClock()/8) % walkside.animLength(), 
                            (int)x - walkside.xOffset - cameraX, (int)y - walkside.yOffset - cameraY);
                    }
                    else
                    {
                        sprite(walkside, (systemClock()/8) % walkside.animLength(), 
                            (int)x - walkside.xOffset - cameraX, (int)y - walkside.yOffset - cameraY);
                    }
                }
                else if (abs(y - destY*TILE_SIZE) > speed)
                {
                    if (y > destY*TILE_SIZE)
                        sprite(walkup, (systemClock()/8) % walkup.animLength(), 
                            (int)x - walkup.xOffset - cameraX, (int)y - walkup.yOffset - cameraY);
                    else
                        sprite(walkdown, (systemClock()/8) % walkdown.animLength(), 
                            (int)x - walkdown.xOffset - cameraX, (int)y - walkdown.yOffset - cameraY);
                }
            }
            if (path.equals("enterhor"))
            {
                if (abs(y - destY*TILE_SIZE) > speed)
                {
                    if (y > destY*TILE_SIZE)
                        sprite(walkup, (systemClock()/8) % walkup.animLength(), 
                            (int)x - walkup.xOffset - cameraX, (int)y - walkup.yOffset - cameraY);
                    else
                        sprite(walkdown, (systemClock()/8) % walkdown.animLength(), 
                            (int)x - walkdown.xOffset - cameraX, (int)y - walkdown.yOffset - cameraY);
                }
                else if (abs(x - destX*TILE_SIZE) > speed)
                {
                    if (x > destX*TILE_SIZE)
                    {
                        //fill(color(255,0,0));
                        //rect((int)x - cameraX,(int)y - cameraY,TILE_SIZE,TILE_SIZE); //DRAW LEFT
                        spriteBackwards(walkside, (systemClock()/8) % walkside.animLength(), 
                            (int)x - walkside.xOffset - cameraX, (int)y - walkside.yOffset - cameraY);
                    }
                    else
                        sprite(walkside, (systemClock()/8) % walkside.animLength(), 
                            (int)x - walkside.xOffset - cameraX, (int)y - walkside.yOffset - cameraY);
                }
            }
        }
    }
}