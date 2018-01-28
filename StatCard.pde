class StatCard
{
    int namePos[];
    int levelPos[];
    int classPos[];
    int healthPos[];
    int accPos[];
    int atkPos[];
    int defPos[];

    String name;
    String level;
    String className;
    int health;
    int curHealth;
    float accuracy;
    float attack;
    float defense;

    public StatCard(String templateFile, String charFile, int hpIn)
    {
        curHealth = hpIn;
        loadTemplate(templateFile);
        loadCharacter(charFile);
    }

    public void loadTemplate(String filename)
    {
        BufferedReader reader = createReader("./data/images/" + filename);

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
        while (line != null)
        {
            String[] args = splitTokens(line, "$");
            if (args[0].equals("name"))
            {
                namePos = new int[2];
                namePos[0] = int(args[1]);
                namePos[1] = int(args[2]);
            }
            else if (args[0].equals("level"))
            {
                levelPos = new int[2];
                levelPos[0] = int(args[1]);
                levelPos[1] = int(args[2]);
            }
            else if (args[0].equals("class"))
            {
                classPos = new int[2];
                classPos[0] = int(args[1]);
                classPos[1] = int(args[2]);
            }
            else if (args[0].equals("health"))
            {
                healthPos = new int[4];
                healthPos[0] = int(args[1]);
                healthPos[1] = int(args[2]);
                healthPos[2] = int(args[3]);
                healthPos[3] = int(args[4]);
            }
            else if (args[0].equals("accuracy"))
            {
                accPos = new int[4];
                accPos[0] = int(args[1]);
                accPos[1] = int(args[2]);
                accPos[2] = int(args[3]);
                accPos[3] = int(args[4]);
            }
            else if (args[0].equals("attack"))
            {
                atkPos = new int[4];
                atkPos[0] = int(args[1]);
                atkPos[1] = int(args[2]);
                atkPos[2] = int(args[3]);
                atkPos[3] = int(args[4]);
            }
            else if (args[0].equals("defense"))
            {
                defPos = new int[4];
                defPos[0] = int(args[1]);
                defPos[1] = int(args[2]);
                defPos[2] = int(args[3]);
                defPos[3] = int(args[4]);
            }

            try
            {
                line = reader.readLine();
            }
            catch (IOException e)
            {
                e.printStackTrace();
                line = null;
            }
        }
    }

    public void loadCharacter(String filename)
    {
        BufferedReader reader = createReader("./data/images/characters/" + filename);

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
        while (line != null)
        {
            String[] args = splitTokens(line, "$");
            if (args[0].equals("name"))
            {
                name = args[1].toUpperCase();
            }
            else if (args[0].equals("level"))
            {
                level = args[1].toUpperCase();
            }
            else if (args[0].equals("class"))
            {
                className = args[1].toUpperCase();
            }
            else if (args[0].equals("health"))
            {
                health = int(args[1]);
                if (curHealth == -1)
                    curHealth = int(args[1]);
            }
            else if (args[0].equals("accuracy"))
            {
                accuracy = float(args[1]);
            }
            else if (args[0].equals("attack"))
            {
                attack = float(args[1]);
            }
            else if (args[0].equals("defense"))
            {
                defense = float(args[1]);
            }

            try
            {
                line = reader.readLine();
            }
            catch (IOException e)
            {
                e.printStackTrace();
                line = null;
            }
        }
    }

    public void show(int x, int y)
    {
        image(statcardBg, x, y);
        for (int i = 0; i < name.length(); i++)
        {
            if (name.charAt(i) != ' ')
            {
                letter(name.charAt(i), x + namePos[0] + i*TILE_SIZE/2, y + namePos[1], 
                    TILE_SIZE/2, TILE_SIZE/2);
            }
        }
        for (int j = 0; j < level.length(); j++)
        {
            if (level.charAt(j) != ' ')
            {
                letter(level.charAt(j), x + levelPos[0] + j*TILE_SIZE/2, y + levelPos[1], 
                    TILE_SIZE/2, TILE_SIZE/2);
            }
        }
        for (int k = 0; k < className.length(); k++)
        {
            if (className.charAt(k) != ' ')
            {
                letter(className.charAt(k), x + classPos[0] + k*TILE_SIZE/2, y + classPos[1], 
                    TILE_SIZE/2, TILE_SIZE/2);
            }
        }

        for (int m = 0; m < health; m++)
        {
            fill(21, 95, 217);
            rect(x + healthPos[0] + m*(healthPos[2]+1), y + healthPos[1], healthPos[2], healthPos[3]);
            if (m < curHealth)
            {
                fill(255, 255, 255);
                rect(x + healthPos[0] + m*(healthPos[2]+1), y + healthPos[1], healthPos[2], healthPos[3]);
            }
        }

        fill(92, 228, 48);
        for (int n = 0; n*(accPos[2]+1) <= 112 - accPos[0]; n++)
        {
            rect(x + accPos[0] + n*(accPos[2]+1), y + accPos[1], accPos[2], accPos[3]);
            rect(x + accPos[0], y + accPos[1], (112 - accPos[0]) * accuracy, accPos[3]);
        }
        for (int o = 0; o*(atkPos[2]+1) <= 112 - atkPos[0]; o++)
        {
            rect(x + atkPos[0] + o*(atkPos[2]+1), y + atkPos[1], atkPos[2], atkPos[3]);
            rect(x + atkPos[0], y + atkPos[1], (112 - atkPos[0]) * attack, atkPos[3]);
        }
        for (int p = 0; p*(defPos[2]+1) <= 112 - defPos[0]; p++)
        {
            rect(x + defPos[0] + p*(defPos[2]+1), y + defPos[1], defPos[2], defPos[3]);
            rect(x + defPos[0], y + defPos[1], (112 - defPos[0]) * defense, defPos[3]);
        }
    }

    public void damage(int dmg)
    {
        curHealth = max(0, curHealth-dmg);
    }
}