class TextBox
{
    NamedMob speakingMob;
    String speaker;
    String dialogue;
    String shown;
    boolean showSetting;
    int curPos;
    boolean done;
    Font myFont;
    int voice;
    int side;
    int timeDone;

    public TextBox()
    {
        speaker = null;
        speakingMob = null;
        dialogue = null;
        shown = null;
        showSetting = false;

        curPos = 0;
        done = false;

        myFont = null;
        voice = 0;
        side = -1;

        timeDone = 0;
    }

    public TextBox(String speakerIn, String dialogueIn, int sideIn)
    {
        speaker = speakerIn.toUpperCase();
        speakingMob = null;
        if (filtering)
            dialogue = filter(dialogueIn);
        dialogue = fixString(dialogue.toUpperCase());
        shown = "";
        showSetting = true;

        curPos = 0;
        done = false;

        myFont = null;
        voice = 0;
        side = sideIn;

        timeDone = 0;
    }
    public TextBox(NamedMob speakerIn, String dialogueIn, int sideIn)
    {
        speakingMob = speakerIn;
        speaker = speakerIn.name.toUpperCase();
        if (filtering)
            dialogue = filter(dialogueIn);
        else
            dialogue = dialogueIn;
        dialogue = fixString(dialogue.toUpperCase());
        //println(dialogue);
        shown = "";
        showSetting = true;

        curPos = 0;
        done = false;

        myFont = null;
        voice = 0;
        side = sideIn;
    }

    private String fixString(String toFix)
    {
        for (int i = 0; i < toFix.length(); i += 14)
        {
            while (toFix.charAt(i) == ' ')
            {
                toFix = removeChar(toFix, i);
            }

            if (toFix.length() > i + 13)
            {
                int prevSpace = i + 13;
                while (prevSpace >= i && toFix.charAt(prevSpace) != ' ')
                {
                    prevSpace--;
                }
                if (prevSpace >= i)
                {
                    while (toFix.charAt(i+13) != ' ' && (toFix.length() <= i + 14 || toFix.charAt(i+14) != ' '))
                    {
                        toFix = insertChar(toFix, prevSpace, ' ');
                    }
                }
            }
        }

        return toFix;
    }

    public void nextLetter()
    {
        if (systemClock() % TEXT_DELAY != 0)
        {
            return;
        }
        char nextChar;
        if (shown.length() < 42 && curPos < dialogue.length())
        {
            nextChar = dialogue.charAt(curPos);
            while (nextChar == ' ')
            {
                shown += nextChar;
                curPos++;
                nextChar = dialogue.charAt(curPos);
            }
            if (shown.length() < 42)
            {
                shown += nextChar;
                curPos++;
                soundHandler.playTalkSound(voice);
            }
        }
    }

    public void advance()
    {
        if (curPos == dialogue.length())
        {
            done = true;
        }
else
        {
            shown = "";
        }
    }

    public boolean isDone()
    {
        return done;
    }

    public void show()
    {
        if (curPos == dialogue.length())
        {
            timeDone++;
            if ((automatic && timeDone >= 20) || (!automatic && buttonPressed > 0))
                advance();
        }
        else if (shown.length() == 42)
        {
            timeDone++;
            if ((automatic && timeDone >= 10) || (!automatic && buttonPressed > 0))
                advance();
        }
        else if (timeDone != 0)
        {
            timeDone = 0;
        }

        drawBackground(true);

        //setting
        for (int i = 0; i < min(16, setting.length()); i++)
        {
            letter(setting.toUpperCase().charAt(i), TILE_SIZE*4+(i*TILE_SIZE/2), TILE_SIZE*2, TILE_SIZE/2, TILE_SIZE/2);
        }

        //speaker
        for (int j = 0; j < min(13, speaker.length()); j++)
        {
            letter(speaker.charAt(j), (int)(TILE_SIZE*4.5)+(j*TILE_SIZE/2), TILE_SIZE*8, TILE_SIZE/2, TILE_SIZE/2);
        }
        letter(':', (int)(TILE_SIZE*4.5)+((min(13, speaker.length()))*TILE_SIZE/2), TILE_SIZE*8, TILE_SIZE/2, TILE_SIZE/2);

        //portrait
        if (speakingMob == null)
        {
            fill(255, 255, 255);
            rect(TILE_SIZE*(6.5+3*side), TILE_SIZE*3.5, TILE_SIZE*-3*side, TILE_SIZE*3);
        }
        else
        {
            if (shown.length() == 42 || curPos == dialogue.length())
            {
                sprite(speakingMob.portrait, 0, (int)(TILE_SIZE*(6.5+3*side)), (int)(TILE_SIZE*3.5), (int)(TILE_SIZE*-3*side), (int)(TILE_SIZE*3));
            }
            else
            {
                sprite(speakingMob.portrait, (systemClock()/8) % 2, 
                    (int)(TILE_SIZE*(6.5+3*side)), (int)(TILE_SIZE*3.5), (int)(TILE_SIZE*-3*side), (int)(TILE_SIZE*3));
            }
        }

        //text
        for (int k = 0; k < shown.length(); k++)
        {
            if (shown.charAt(k) != ' ')
                letter(shown.charAt(k), (int)(TILE_SIZE*4.5)+((k % 14)*TILE_SIZE/2), TILE_SIZE*9+((k / 14)*TILE_SIZE), TILE_SIZE/2, TILE_SIZE/2, myFont);
        }

        //triangle
        //println(systemClock());
        if ((systemClock()/16) % 2 == 0)
        {
            if (shown.length() == 42 || curPos == dialogue.length())
            {
                fill(color(255, 255, 255));
                rect(TILE_SIZE*8, TILE_SIZE*12, TILE_SIZE/2, 1);
                rect(TILE_SIZE*8+1, TILE_SIZE*12+1, TILE_SIZE/2-2, 1);
                rect(TILE_SIZE*8+2, TILE_SIZE*12+2, TILE_SIZE/2-4, 1);
                rect(TILE_SIZE*8+3, TILE_SIZE*12+3, TILE_SIZE/2-6, 1);
            }
        }
    }

    private void drawBackground(boolean sprited)
    {
        if (sprited)
        {
            pushMatrix();
            scale(-side, 1);
            if (side == -1)
                image(dialogueBg, TILE_SIZE*3, TILE_SIZE, TILE_SIZE*10, TILE_SIZE*12);
            else if (side == 1)
                image(dialogueBg, TILE_SIZE*3*(-side) - TILE_SIZE*10, TILE_SIZE, TILE_SIZE*10, TILE_SIZE*12);
            popMatrix();
        }
        else
        {
            fill(color(0, 0, 0));
            rect(TILE_SIZE*3, TILE_SIZE, (int)(TILE_SIZE*-10*side), TILE_SIZE*2);
            rect(TILE_SIZE*3, TILE_SIZE*3, (int)(TILE_SIZE*4*side), TILE_SIZE*4);
            rect(TILE_SIZE*3, TILE_SIZE*7, (int)(TILE_SIZE*-10*side), TILE_SIZE*6);
        }
    }
}

public String insertChar(String s, int pos, char c)
{
    String before = s.substring(0, pos);
    String after = s.substring(pos);
    return before + c + after;
}

public String removeChar(String s, int pos)
{
    String before = s.substring(0, pos);
    String after = s.substring(pos + 1);
    return before + after;
}

public String replaceChars(String s, char find, char replace)
{
    String newString = "";

    for (int i = 0; i < s.length(); i++)
    {
        if (s.charAt(i) == '\\')
        {
            newString += s.charAt(i+1);
            i += 1;
        }
        else if (s.charAt(i) == find)
        {
            newString += replace;
        }
        else
        {
            newString += s.charAt(i);
        }
    }
    return newString;
}

public int sideToInt(String side)
{
    if (side.equals("left"))
        return -1;
    else if (side.equals("right"))
        return 1;
    else
        return 0;
}

public String filter(String input)
{
    int foundIndex = -1;
    for (int i = 0; i < filteredWords.size(); i++)
    {
        foundIndex = input.indexOf(filteredWords.get(i));
        if (foundIndex != -1)
        {
            String before = input.substring(0, foundIndex);
            String after = input.substring(foundIndex+filteredWords.get(i).length());
            input = before + newWords.get(i) + after;
        }
    }
    return input;
}