class Sprite
{
    PImage[] frames;
    int size;

    int xOffset;
    int yOffset;

    public Sprite(PImage[] framesIn)
    {
        frames = framesIn;
        size = frames.length;
        xOffset = 0;
        yOffset = 0;
    }

    public PImage get(int frame)
    {
        return frames[frame];
    }

    public int animLength()
    {
        return size;
    }
}

Sprite loadSprite(String filename, int size)
{
    PImage frames[] = new PImage[size];

    int dotIndex = filename.indexOf(".");
    if (dotIndex != -1)
    {
        String name, ext;
        name = filename.substring(0, dotIndex);
        ext = filename.substring(dotIndex);

        for (int i = 0; i < size; i++)
        {
            frames[i] = loadImage("./data/images/" + name + i + ext);
            println("loaded " + name + i + ext);
        }
        return new Sprite(frames);
    }
    else
    {
        return null;
    }
}
Sprite loadSprite(String fileName, String extension, int size)
{
    PImage frames[] = new PImage[size];

    for (int i = 0; i < size; i++)
    {
        frames[i] = loadImage("./data/images/" + fileName + i + extension);
        println("loaded " + fileName + i + extension);
    }

    return new Sprite(frames);
}

void sprite(Sprite img, int frame, int a, int b)
{
    image(img.get(frame), a, b);
}
void sprite(Sprite img, int frame, int a, int b, int c, int d)
{
    pushMatrix();
    if (c < 0)
    {
        scale(-1, 1);
        image(img.get(frame), -a+c, b, -c, d);
    }
    else
        image(img.get(frame), a, b, c, d);
    popMatrix();
}
void spriteBackwards(Sprite img, int frame, int a, int b)
{
    pushMatrix();
    scale(-1, 1);
    image(img.get(frame), -a-TILE_SIZE, b);
    popMatrix();
}

class SpriteDict
{
    ArrayList<Sprite> sprites;
    ArrayList<String> keys;

    public SpriteDict()
    {
        sprites = new ArrayList<Sprite>();
        keys = new ArrayList<String>();
    }

    public int size()
    {
        return sprites.size();
    }

    public int hasKey(String keyName)
    {
        for (int s = 0; s < keys.size(); s++)
        {
            if (keys.get(s).equals(keyName))
                return s;
        }
        return -1;
    }

    public void set(String keyName, Sprite value)
    {
        int index = hasKey(keyName);
        if (index == -1)
        {
            keys.add(keyName);
            sprites.add(value);
        }
        else
        {
            sprites.set(index, value);
        }
    }

    public Sprite get(String keyName)
    {
        int index = hasKey(keyName);
        if (index == -1)
        {
            return null;
        }
        else
        {
            return sprites.get(index);
        }
    }
}