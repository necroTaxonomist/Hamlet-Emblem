class Director
{
    ArrayList<Command> pending;
    int current;

    public Director()
    {
        pending = new ArrayList<Command>();
        current = -1;
    }

    public void run()
    {
        if (current >= pending.size())
            return;

        if (current == -1 || pending.get(current).isFinished())
        {
            current++;
            if (current < pending.size())
            {
                pending.get(current).begin();
            }
        }
        else
        {
            pending.get(current).execute();
        }
    }

    public void enter(Command newCommand)
    {
        if (newCommand != null)
            pending.add(newCommand);
    }

    public void clearCommands()
    {
        pending = new ArrayList<Command>();
        current = -1;
    }

    public void fileEntry(String fileName)
    {
        BufferedReader reader = createReader("./data/scripts/" + fileName + ".txt");

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
                enter(cmd(line));
            }
        }
    }
}