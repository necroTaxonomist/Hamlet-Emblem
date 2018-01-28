class Arras
{
    Sprite mySprite;
    int x,y;
    
    public Arras(int xIn, int yIn)
    {
        mySprite = loadSprite("arras", ".png", 1);
        x = xIn;
        y = yIn;
    }
    
    public void show()
    {
        if (mySprite != null)
            sprite(mySprite, (systemClock()/4) % mySprite.animLength(), x, y);
    }
    
}