class Font
{
    PImage letters[][];
    String fileName;

    public Font(String fileIn)
    {
        fileName = fileIn;

        PImage fullSheet = loadImage("./data/images/text/" + fileIn);

        BufferedReader reader = createReader("./data/images/text/" + fileName.substring(0, fileName.length()-4) + ".txt");

        String line;
        try
        {
            line = reader.readLine();
        }
        catch (IOException e)
        {
            e.printStackTrace();
            line = null;
        }

        if (line != null)
        {
            int xPos = line.indexOf("x");
            int openParen = line.indexOf("(");
            int closeParen = line.indexOf(")");

            int w = int(line.substring(0, xPos));
            int h = int(line.substring(xPos+1, openParen));
            int s = int(line.substring(openParen+1, closeParen));

            letters = new PImage[w][h];

            for (int x = 0; x < w; x++)
            {
                for (int y = 0; y < h; y++)
                {
                    letters[x][y] = fullSheet.get(s+x*s*2, s+y*s*2, s, s);
                }
            }
        }
    }

    public String getFilename()
    {
        return fileName.substring(0, fileName.indexOf("."));
    }

    public PImage findChar(char c)
    {
        if (fileName.equals("stdtext.png"))
        {
            if (c >= 48 && c <= 57)
            {
                return letters[c-48][0];
            }
            else if (c >= 65 && c <= 74)
            {
                return letters[c-65][1];
            }
            else if (c >= 75 && c <= 84)
            {
                return letters[c-75][2];
            }
            else if (c >= 85 && c <= 90)
            {
                return letters[c-85][3];
            }
            else if (c == ',') { 
                return letters[6][3];
            }
            else if (c == '.') { 
                return letters[7][3];
            }
            else if (c == '!') { 
                return letters[8][3];
            }
            else if (c == '?') { 
                return letters[9][3];
            }
            else if (c >= 58 && c <= 59)
            {
                return letters[c-58][4];
            }
            else if (c == '\'' || c == '’') { 
                return letters[2][4];
            }
            else if (c == '%') { 
                return letters[3][4];
            }
            else if (c == '×') { 
                return letters[4][4];
            }
            else if (c == '/') { 
                return letters[5][4];
            }
            else if (c >= 40 && c <= 41)
            {
                return letters[c-40+6][4];
            }
            else if (c == '“') { 
                return letters[8][4];
            }
            else if (c == '”' || c == '"') { 
                return letters[9][4];
            }
            else
            {
                return null;
            }
        }
        else
        {
            BufferedReader reader = createReader("./data/images/text/" + fileName.substring(0, fileName.indexOf(".")) + ".txt");
            String line;
            int lineNum = -1;
            try
            {
                line = reader.readLine();
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            while (true)
            {
                try
                {
                    line = reader.readLine();
                    lineNum++;
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
                    //println("      " + line);
                    int pos = line.indexOf(c);
                    if (pos != -1)
                    {
                        return letters[pos][lineNum];
                    }
                }
            }
            return null;
        }
    }
}

public PImage globalFindChar(char c)
{
    PImage foundChar;
    for (Font f : fontList)
    {
        foundChar = f.findChar(c);
        if (foundChar != null)
            return foundChar;
    }
    return null;
}

public void letter(char ch, int a, int b)
{
    PImage toShow = globalFindChar(ch);
    if (toShow != null)
    {
        image(toShow, a, b);
    }
}
public void letter(char ch, int a, int b, int c, int d)
{
    PImage toShow = globalFindChar(ch);
    if (toShow != null)
    {
        image(toShow, a, b, c, d);
    }
}
public void letter(char ch, int a, int b, int c, int d, String fontName)
{
    Font chosenFont = null;
    for (Font f : fontList)
    {
        if (f.getFilename().equals(fontName))
        {
            chosenFont = f;
            break;
        }
    }
    if (chosenFont != null)
    {
        PImage toShow = chosenFont.findChar(ch);
        if (toShow != null)
        {
            image(toShow, a, b, c, d);
        }
    }
}
public void letter(char ch, int a, int b, int c, int d, Font chosenFont)
{
    if (chosenFont != null)
    {
        PImage toShow = chosenFont.findChar(ch);
        if (toShow != null)
        {
            image(toShow, a, b, c, d);
        }
    }
    else
    {
        letter(ch, a, b, c, d);
    }
}