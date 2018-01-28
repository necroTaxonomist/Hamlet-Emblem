class SoundHandler
{
    Minim minim;
    AudioPlayer music;
    AudioPlayer sfx;
    AudioPlayer walking;

    ArrayList<AudioSample> talkSounds;
    ArrayList<String> talkSoundNames;

    AudioSample laughSound;
    AudioSample hitSound;
    AudioSample shwingSound;

    public SoundHandler(Object sketch)
    {
        minim = new Minim(sketch);
        talkSounds = new ArrayList<AudioSample>();
        talkSoundNames = new ArrayList<String>();

        laughSound = minim.loadSample( "./data/sounds/laugh.mp3", 512);
        hitSound = minim.loadSample( "./data/sounds/attack.mp3", 512);
        shwingSound = minim.loadSample( "./data/sounds/shwing.wav", 512);
    }

    public int loadTalkSound(String filename)
    {
        AudioSample newSample = minim.loadSample( "./data/sounds/talksounds/" + filename, 512);
        talkSounds.add(newSample);
        talkSoundNames.add(filename);
        return talkSounds.size() - 1;
    }

    public void playTalkSound(String filename)
    {
        for (int i = 0; i < talkSoundNames.size(); i++)
        {
            if (talkSoundNames.get(i).equals(filename))
            {
                talkSounds.get(i).trigger();
            }
        }
    }
    public void playTalkSound(int index)
    {
        talkSounds.get(index).trigger();
    }
    public void laugh()
    {
        laughSound.trigger();
    }
    public void hit()
    {
        hitSound.trigger();
    }
    public void shwing()
    {
        shwingSound.trigger();
    }

    public int talkSoundIndex(String filename)
    {
        for (int i = 0; i < talkSoundNames.size(); i++)
        {
            if (talkSoundNames.get(i).equals(filename))
            {
                return i;
            }
        }
        return -1;
    }

    public void playMusic(String filename)
    {
        if (music != null)
            stopMusic();
        music = minim.loadFile("./data/sounds/music/" + filename);
        music.setGain(30);
        restartMusic();
    }

    public void restartMusic()
    {
        music.rewind();
        if (!music.isPlaying())
            music.play();
    }

    public void stopMusic()
    {
        music.pause();
    }

    public void beginWalk()
    {
        if (walking != null)
            endWalk();
        walking = minim.loadFile("./data/sounds/walk.mp3");
        walking.loop();
    }
    public void endWalk()
    {
        if (walking != null)
            walking.pause();
    }
}