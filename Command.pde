class Command
{
    String type;
    String[] args;
    Mob with;
    TextBox text;
    int timer;
    Fight fight;
    int[] intArgs;

    public Command(String typeIn, String[] argsIn)
    {
        type = typeIn;
        args = argsIn;
        with = null;
        text = null;
        timer = -1;
        fight = null;
        intArgs = null;
    }

    public void begin()
    {
        if (type.equals("wait"))
        {
            timer = int(args[0]);
        }
        else if (type.equals("add"))
        {
            Mob newMob;
            if (args.length == 3)
            {
                newMob = new Mob(args[0], int(args[1]), int(args[2]));
                println("added " + args[0] + " at (" + args[1] + "," + args[2] + ")");
            }
            else if (args.length > 3)
            {
                newMob = new NamedMob(args[0], int(args[1]), int(args[2]), args[3]);
                println("added " + args[0] + " at (" + args[1] + "," + args[2] + ") from file " + args[3]);
            }
            else
            {
                newMob = null;
                println("failed to add");
            }
            register.add(newMob);
        }
        else if (type.equals("move"))
        {
            for (Mob m : register)
            {
                if (m.name.equals(args[0]))
                {
                    with = m;
                    break;
                }
            }
            if (with != null)
            {
                soundHandler.beginWalk();
                with.goTo(int(args[1]), int(args[2]), float(args[3]), args[4]);
            }
        }
        else if (type.equals("teleport"))
        {
            for (Mob m : register)
            {
                if (m.name.equals(args[0]))
                {
                    with = m;
                    break;
                }
            }
            if (with != null)
            {
                with.x = TILE_SIZE * int(args[1]);
                with.y = TILE_SIZE * int(args[2]);
            }
        }
        else if (type.equals("kill"))
        {
            for (Mob m : register)
            {
                if (m.name.equals(args[0]))
                {
                    with = m;
                    break;
                }
            }
            register.remove(with);
        }
        else if (type.equals("textbox"))
        {
            soundHandler.endWalk();
            for (Mob m : register)
            {
                if (m.name.equals(args[0]))
                {
                    with = m;
                    break;
                }
            }
            if (with != null)
            {
                //println("found the fucker");
                text = new TextBox((NamedMob)with, args[1], sideToInt(args[2]));
                if (((NamedMob)with).myFont != null)
                {
                    //println("well, he's got a font");
                    text.myFont = ((NamedMob)with).myFont;
                }
                if (((NamedMob)with).voice != -1)
                {
                    text.voice = ((NamedMob)with).voice;
                }
            }
            else
                text = new TextBox(args[0], args[1], sideToInt(args[2]));

            //println(args.length);

            if (args.length >= 4)
            {
                //println("fucking ARGUMENTS!");
                Font chosenFont = null;
                for (Font f : fontList)
                {
                    if (f.getFilename().equals(args[2].substring(0, args[2].indexOf(".")))) //index out of range -1 means fucked up commas
                    {
                        chosenFont = f;
                        println("NEWFONT");
                        break;
                    }
                }
                text.myFont = chosenFont;
            }
        }
        else if (type.equals("messagebox"))
        {
            text = new MsgBox(args[0]);
        }
        else if (type.equals("fight"))
        {
            NamedMob left = null;
            NamedMob right = null;
            for (Mob m : register)
            {
                if (m.name.equals(args[0]))
                {
                    left = (NamedMob)m;
                }
                if (m.name.equals(args[1]))
                {
                    right = (NamedMob)m;
                }
                if (left != null && right != null)
                {
                    break;
                }
            }
            fight = new Fight(left, right, sideToInt(args[2]), int(args[3]));
            fighting = true;
        }
        else if (type.equals("titlescreen"))
        {
            titleScreen = new TitleScreen(int(args[0]));
        }
        else if (type.equals("titleBackground"))
        {
            if (titleScreen != null)
            {
                titleScreen.setBackground(args[0]);
            }
        }
        else if (type.equals("titleElement"))
        {
            if (titleScreen != null)
            {
                TitleElement e = null;
                if (args.length == 5)
                {
                    e = new TitleElement(args[0], args[1], int(args[2]), int(args[3]), int(args[4]));
                }
                else if (args.length == 8)
                {
                    e = new TitleElement(args[0], args[1], int(args[2]), int(args[3]), int(args[4]), int(args[5]), int(args[6]), int(args[7]));
                }
                if (e != null)
                {
                    titleScreen.addElement(e);
                }
            }
        }
        else if (type.equals("closeTitle"))
        {
            if (titleScreen != null)
            {
                titleScreen = null;
            }
        }
        else if (type.equals("setting"))
        {
            setting = args[0];
        }
        else if (type.equals("loadMap"))
        {
            background.loadMap(args[0]);
        }
        else if (type.equals("loadFont"))
        {
            fontList.add(new Font(args[0]));
            println("loaded font " + args[0]);
        }
        else if (type.equals("loadTileset"))
        {
            background.loadTileset(args[0]);
        }
        else if (type.equals("loadScript"))
        {
            shown = false;
            register = new ArrayList<Mob>();
            curtains = new ArrayList<Arras>();
            background = new Background();
            director.clearCommands();
            director.fileEntry(args[0]);
        }
        else if (type.equals("playMusic"))
        {
            soundHandler.playMusic(args[0]);
        }
        else if (type.equals("stopMusic"))
        {
            soundHandler.stopMusic();
        }
        else if (type.equals("setCamera"))
        {
            cameraX = int(args[0]);
            cameraY = int(args[1]);
        }
        else if (type.equals("skyboxColor"))
        {
            skybox = color(int(args[0]), int(args[1]), int(args[2]), int(args[3]));
        }
        else if (type.equals("fadeSkybox"))
        {
            intArgs = new int[8];

            intArgs[0] = int(args[0]);
            intArgs[1] = (intArgs[0] - (int)(red(skybox))) / int(args[4]);

            intArgs[2] = int(args[1]);
            intArgs[3] = (intArgs[2] - (int)(green(skybox))) / int(args[4]);

            intArgs[4] = int(args[2]);
            intArgs[5] = (intArgs[4] - (int)(blue(skybox))) / int(args[4]);

            intArgs[6] = int(args[3]);
            intArgs[7] = (intArgs[6] - (int)(alpha(skybox))) / int(args[4]);
        }
        else if (type.equals("show"))
        {
            shown = true;
        }
        else if (type.equals("hide"))
        {
            shown = false;
        }
        else if (type.equals("arras"))
        {
            Arras newArras = new Arras(int(args[0]) * TILE_SIZE, int(args[1]) * TILE_SIZE);
            curtains.add(newArras);
        }
        else if (type.equals("laugh"))
        {
            soundHandler.laugh();
        }
        else if (type.equals("hit"))
        {
            soundHandler.hit();
        }
        else if (type.equals("shwing"))
        {
            soundHandler.shwing();
        }
    }

    public void execute()
    {
        if (type.equals("wait"))
        {
            timer--;
        }
        else if (type.equals("textbox") || type.equals("messagebox"))
        {
            if (text != null)
            {
                text.nextLetter();
                text.show();
            }
        }
        else if (type.equals("fight"))
        {
            if (fight != null)
            {
                fight.show();
            }
        }
        else if (type.equals("panCamera"))
        {
            int destX = int(args[0]);
            int destY = int(args[1]);
            float speed = int(args[2]);
            if (args[3].equals("entervert"))
            {
                if (abs(cameraX - destX) > speed)
                {
                    if (cameraX > destX)
                        cameraX -= speed;
                    else
                        cameraX += speed;
                }
                else if (abs(cameraY - destY) > speed)
                {
                    cameraX = destX;
                    if (cameraY > destY)
                        cameraY -= speed;
                    else
                        cameraY += speed;
                }
                else
                {
                        cameraX = destX;
                        cameraY = destY;
                }
            }
            else if (args[3].equals("enterhor"))
            {
                if (abs(cameraY - destY) > speed)
                {
                    if (cameraY > destY)
                        cameraY -= speed;
                    else
                        cameraY += speed;
                }
                else if (abs(cameraX - destX) > speed)
                {
                    cameraY = destY;
                    if (cameraX > destX)
                        cameraX -= speed;
                    else
                        cameraX += speed;
                }
                else
                {
                    cameraX = destX;
                    cameraY = destY;
                }
            }
        }
        else if (type.equals("fadeSkybox"))
        {
            int newRed;
            if (abs(intArgs[0] - (int)(red(skybox))) > abs(intArgs[1]))
            {
                newRed = (int)(red(skybox)) + intArgs[1];
            }
            else
            {
                newRed = intArgs[0];
            }
            int newGreen;
            if (abs(intArgs[2] - (int)(green(skybox))) > abs(intArgs[3]))
            {
                newGreen = (int)(green(skybox)) + intArgs[3];
            }
            else
            {
                newGreen = intArgs[2];
            }
            int newBlue;
            if (abs(intArgs[4] - (int)(blue(skybox))) > abs(intArgs[5]))
            {
                newBlue = (int)(blue(skybox)) + intArgs[5];
            }
            else
            {
                newBlue = intArgs[4];
            }
            int newAlpha;
            if (abs(intArgs[6] - (int)(alpha(skybox))) > abs(intArgs[7]))
            {
                newAlpha = (int)(alpha(skybox)) + intArgs[7];
            }
            else
            {
                newAlpha = intArgs[6];
            }

            skybox = color(newRed, newGreen, newBlue, newAlpha);
        }
    }

    public boolean isFinished()
    {
        if (type.equals("wait"))
        {
            return timer == 0;
        }
        else if (type.equals("move"))
        {
            if (with.getX() == int(args[1]) && with.getY() == int(args[2]))
            {
                println("moved " + args[0] + " to (" + args[1] + "," + args[2] + ")");
            }
            if (with != null && with.getX() == int(args[1]) && with.getY() == int(args[2]))
            {
                soundHandler.endWalk();
                return true;
            }
            else
                return false;
        }
        else if (type.equals("textbox") || type.equals("messagebox"))
        {
            return text == null || text.isDone();
        }
        else if (type.equals("fight"))
        {
            if (fight == null || fight.isDone())
            {
                fighting = false;
                return true;
            }
            else
                return false;
        }
        else if (type.equals("panCamera"))
        {
            return cameraX == int(args[0]) && cameraY == int(args[1]);
        }
        else if (type.equals("fadeSkybox"))
        {
            return (red(skybox) == intArgs[0] && green(skybox) == intArgs[2] && blue(skybox) == intArgs[4] && alpha(skybox) == intArgs[6]);
        }
        else if (type.equals("waitForPress"))
        {
            return buttonPressed > 0;
        }
        else
        {
            return true;
        }
    }
}

public Command cmd(String command)
{
    if (command.equals(""))
        return null;

    command = replaceChars(command, ',', '§');

    int openParen = command.indexOf("(");
    int closeParen = command.indexOf(")");

    String type = command.substring(0, openParen);
    String[] args = splitTokens(command.substring(openParen+1, closeParen), "§");

    return new Command(type, args);
}