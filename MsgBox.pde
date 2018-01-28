class MsgBox extends TextBox
{
    public MsgBox(String dialogueIn)
    {
        super();
        if (dialogueIn.length() > 15)
            dialogue = dialogueIn.toUpperCase().substring(0, 15);
        else
            dialogue = dialogueIn.toUpperCase();
        shown = "";

        curPos = 0;
        done = false;
    }

    public void nextLetter()
    {
        if (systemClock() % TEXT_DELAY != 0)
        {
            return;
        }
        char nextChar;
        if (shown.length() < 15 && curPos < dialogue.length())
        {
            nextChar = dialogue.charAt(curPos);
            while (nextChar == ' ')
            {
                shown += nextChar;
                curPos++;
                nextChar = dialogue.charAt(curPos);
            }
            if (shown.length() < 15)
            {
                shown += nextChar;
                curPos++;
                soundHandler.playTalkSound(0);
            }
        }
    }

    public void advance()
    {
        if (curPos == dialogue.length())
        {
            done = true;
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
            if ((automatic && timeDone >= 50) || (!automatic && buttonPressed > 0))
                advance();
        }
        else if (timeDone != 0)
        {
            timeDone = 0;
        }

        drawBackground(true);

        //text
        for (int k = 0; k < shown.length(); k++)
        {
            if (shown.charAt(k) != ' ')
                letter(shown.charAt(k), (int)(TILE_SIZE*4)+((k % 16)*TILE_SIZE/2), TILE_SIZE*7+((k / 16)*TILE_SIZE), TILE_SIZE/2, TILE_SIZE/2);
        }

        //triangle
        //println(systemClock());
        if ((systemClock()/16) % 2 == 0)
        {
            if (curPos == dialogue.length())
            {
                fill(color(255, 255, 255));
                rect(TILE_SIZE*8, TILE_SIZE*8, TILE_SIZE/2, 1);
                rect(TILE_SIZE*8+1, TILE_SIZE*8+1, TILE_SIZE/2-2, 1);
                rect(TILE_SIZE*8+2, TILE_SIZE*8+2, TILE_SIZE/2-4, 1);
                rect(TILE_SIZE*8+3, TILE_SIZE*8+3, TILE_SIZE/2-6, 1);
            }
        }
    }

    private void drawBackground(boolean sprited)
    {
        if (sprited)
        {
            image(messageBg, TILE_SIZE*3, TILE_SIZE*6.5, TILE_SIZE*10, TILE_SIZE*2);
        }
        else
        {
            fill(color(0, 0, 0));
            rect(TILE_SIZE*3, TILE_SIZE*6.5, TILE_SIZE*10, TILE_SIZE*2);
        }
    }
}