class Background
{
    SpriteDict tileset;
    Sprite bg[][];

    public Background()
    {
        loadTileset();
    }

    public void show()
    {
        if (bg == null)
            return;
        for (int x = 0; x < bg.length; x++)
        {
            for (int y = 0; y < bg[0].length; y++)
            {
                drawTile(x,y);
            }
        }
    }

    public boolean drawTile(int x, int y)
    {
        Sprite toShow = bg[x][y];
        if (toShow != null)
        {
            int frame = (systemClock()/TILE_DELAY) % toShow.animLength();
            sprite(toShow, frame, x*TILE_SIZE - cameraX, y*TILE_SIZE - cameraY, TILE_SIZE, TILE_SIZE);
            return true;
        }
        else
            return false;
    }

    public void newTile(String input)
    {
        if (input.equals(""))
            return;

        String[] args = splitTokens(input, "$");

        String keyName;
        if (args[1].equals("a"))
            keyName = args[0];
        else
            keyName = args[0] + args[1];

        print(keyName + ": ");

        String fileName = args[3].substring(0, args[3].length()-4);
        String extension = args[3].substring(args[3].length()-4);
        int size = int(args[2]);

        Sprite tile = loadSprite("tiles/" + fileName, extension, size);

        tileset.set(keyName, tile);
    }

    public void loadTileset()
    {
        loadTileset("outsideTiles");
    }
    public void loadTileset(String fileName)
    {
        tileset = new SpriteDict();
        BufferedReader reader = createReader("./data/images/tiles/" + fileName + ".txt");
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
                return;
            }
            else
            {
                newTile(line);
            }
        }
    }

    public void loadMap(String fileName)
    {
        BufferedReader reader = createReader("./data/maps/" + fileName + ".txt");
        String twoBefore = "";
        String prevLine = "";
        String line = "";
        int latitude = -1;

        try
        {
            line = reader.readLine();
        }
        catch (IOException e)
        {
            e.printStackTrace();
            line = null;
        }
        String dimen[] = splitTokens(line, "x");
        bg = new Sprite[int(dimen[0])][int(dimen[1])];
        line = "";

        while (true)
        {
            twoBefore = prevLine;
            prevLine = line;
            try
            {
                line = reader.readLine();
            }
            catch (IOException e)
            {
                e.printStackTrace();
                line = null;
            }

            if (prevLine == null)
            {
                return;
            }
            else if (!prevLine.equals(""))
            {
                latitude++;
                mapLine(twoBefore, prevLine, line, latitude);
            }
        }
    }

    public void mapLine(String above, String middle, String below, int lat)
    {
        for (int i = 0; i < 16; i++)
        {
            bg[i][lat] = mapTile(above, middle, below, i);
        }
    }

    public Sprite mapTile(String above, String middle, String below, int lon)
    {
        char keyChar = middle.charAt(lon);
        String keyName = "" + keyChar;

        if (above != null && !above.equals("") && above.charAt(lon) != keyChar)
        {
            keyName += 't';
        }
        else if (below != null && !below.equals("") && below.charAt(lon) != keyChar)
        {
            keyName += 'b';
        }

        if (lon+1 < middle.length() && middle.charAt(lon+1) != keyChar)
        {
            keyName += 'r';
        }
        if (lon-1 >= 0 && middle.charAt(lon-1) != keyChar)
        {
            keyName += 'l';
        }

        /*if (keyName.charAt(0) == '+')
         println("FFFFFFFFFFFFFFFFFFFFF " + keyName + " FFFFFFFFFFFFFFF");*/

        Sprite toShow = tileset.get(keyName);
        while (toShow == null)
        {
            if (keyName.length() == 1)
                return null;
            keyName = keyName.substring(0, keyName.length()-1);
            toShow = tileset.get(keyName);
        }
        return toShow;
    }
}