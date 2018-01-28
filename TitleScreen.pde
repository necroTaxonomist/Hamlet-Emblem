class TitleScreen
{
    int myFPS;
    ArrayList<TitleElement> elements;
    Sprite background;
    boolean shown;

    public TitleScreen(int fpsIn)
    {
        myFPS = fpsIn;
        elements = new ArrayList<TitleElement>();
        background = null;

        shown = true;
    }

    public void show()
    {
        if (background != null)
        {
            sprite(background, 0, 0, 0);
        }
        for (TitleElement e : elements)
        {
            e.show((int)(myFPS*systemClock()/frameRate));
        }
    }

    public void setBackground(String filename)
    {
        background = loadSprite("titlescreen/" + filename, 1);
    }

    public void addElement(TitleElement e)
    {
        elements.add(0, e);
    }
}

class TitleElement
{
    String name;
    Sprite sprite;
    float x, y;
    int destX, destY;
    float xSpeed, ySpeed;

    public TitleElement(String nameIn, String filename, int size, int xIn, int yIn)
    {
        name = nameIn;
        sprite = loadSprite("titlescreen/" + filename, size);
        x = 0.0 + xIn;
        y = 0.0 + yIn;

        destX = 0;
        destY = 0;
        xSpeed = 0;
        ySpeed = 0;
    }

    public TitleElement(String nameIn, String filename, int size, int xIn, int yIn, int dxIn, int dyIn, float speed)
    {
        name = nameIn;
        sprite = loadSprite("titlescreen/" + filename, size);
        x = 0.0 + xIn;
        y = 0.0 + yIn;

        destX = dxIn;
        destY = dyIn;

        float angle = atan2(destY-y, destX-x);

        xSpeed = speed * cos(angle);
        ySpeed = speed * sin(angle);
    }

    public void show(int frame)
    {
        if (xSpeed != 0)
        {
            if (destX-x > xSpeed)
            {
                x += xSpeed;
            }
            else
            {
                x = destX;
                xSpeed = 0;
            }
        }
        if (ySpeed != 0)
        {
            if (destY-y > ySpeed)
            {
                y += ySpeed;
            }
            else
            {
                y = destY;
                ySpeed = 0;
            }
        }

        sprite(sprite, frame % sprite.animLength(), (int)x, (int)y);
    }
}