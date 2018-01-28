class Mob
{
    String name;
    float x, y;
    int destX, destY;
    float speed;
    String path;
    String direction;

    public Mob(String nameIn, int xIn, int yIn)
    {
        name = nameIn;
        x = xIn*TILE_SIZE;
        y = yIn*TILE_SIZE;
        destX = 0;
        destY = 0;
        speed = 0;
        direction = "notmoving";
    }

    public int getX()
    {
        return (int)(x / TILE_SIZE);
    }
    public int getY()
    {
        return (int)(y / TILE_SIZE);
    }

    public boolean stopped()
    {
        return speed <= 0;
    }

    public void act()
    {
        if (speed > 0)
        {
            if (path.equals("entervert"))
            {
                if (abs(x - destX*TILE_SIZE) > speed)
                {
                    if (x > destX*TILE_SIZE)
                        x -= speed;
                    else
                        x += speed;
                }
                else if (abs(y - destY*TILE_SIZE) > speed)
                {
                    x = destX*TILE_SIZE;
                    if (y > destY*TILE_SIZE)
                        y -= speed;
                    else
                        y += speed;
                }
                else
                {
                    x = destX*TILE_SIZE;
                    y = destY*TILE_SIZE;
                    speed = 0;
                }
            }
            if (path.equals("enterhor"))
            {
                if (abs(y - destY*TILE_SIZE) > speed)
                {
                    if (y > destY*TILE_SIZE)
                        y -= speed;
                    else
                        y += speed;
                }
                else if (abs(x - destX*TILE_SIZE) > speed)
                {
                    y = destY*TILE_SIZE;
                    if (x > destX*TILE_SIZE)
                        x -= speed;
                    else
                        x += speed;
                }
                else
                {
                    x = destX*TILE_SIZE;
                    y = destY*TILE_SIZE;
                    speed = 0;
                }
            }
        }
        drawSelf();
    }

    public void goTo(int toX, int toY, float atSpeed, String withPath)
    {
        destX = toX;
        destY = toY;
        speed = atSpeed;
        path = withPath;
    }

    public void drawSelf()
    {
        fill(color(255, 0, 0));
        rect((int)x, (int)y, TILE_SIZE, TILE_SIZE);
    }
}