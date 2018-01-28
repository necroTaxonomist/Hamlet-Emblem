int ENTRY_SPEED = 4;
int MOVMENT_SPEED = 1;

int FIRST_PAUSE = 60;
int SECOND_PAUSE = 120;

class Fight
{
    StatCard leftCard;
    StatCard rightCard;

    NamedMob leftFighter;
    NamedMob rightFighter;

    int attacker;
    int damage;

    String phase;
    int rightCardPos;
    boolean leftCardShown;

    String attackMsg;
    String damageMsg;

    int pauseTime;

    int attackerPos;

    int dealt;

    public Fight(NamedMob lfIn, NamedMob rfIn, int atkrIn, int dmgIn)
    {
        leftFighter = lfIn;
        rightFighter = rfIn;
        attacker = atkrIn;
        damage = dmgIn;
        leftCard = new StatCard("statcard.txt", leftFighter.statfile, leftFighter.hp);
        rightCard = new StatCard("statcard.txt", rightFighter.statfile, rightFighter.hp);

        phase = "entry";
        rightCardPos = TILE_SIZE*16;
        leftCardShown = false;

        if (attacker == -1)
            attackMsg = leftFighter.name.toUpperCase() + " ATTACKS!";
        else if (attacker == 1)
            attackMsg = rightFighter.name.toUpperCase() + " ATTACKS!";

        damageMsg = damage + " DAMAGE!";

        pauseTime = -1;

        attackerPos = (int)(TILE_SIZE*3.5);

        dealt = 0;
    }

    public void show()
    {
        if (phase.equals("entry"))
        {
            if (!leftCardShown)
            {
                if (rightCardPos > 0)
                    rightCardPos -= ENTRY_SPEED;
                else
                {
                    rightCardPos = 0;
                    leftCardShown = true;
                }
                rightCard.show(rightCardPos, TILE_SIZE*15-88);
            }
            else
            {
                if (rightCardPos < TILE_SIZE*8)
                    rightCardPos += ENTRY_SPEED;
                else
                {
                    rightCardPos = TILE_SIZE*8;
                    phase = "pause1";
                    pauseTime = FIRST_PAUSE;
                }
                rightCard.show(rightCardPos, TILE_SIZE*15-88);
                leftCard.show(rightCardPos-120, TILE_SIZE*15-88);
            }

            sprite(leftFighter.battleIdle, 0, (int)(TILE_SIZE*4.5) - leftFighter.battleIdle.xOffset, TILE_SIZE*9 - leftFighter.battleIdle.yOffset);
            sprite(rightFighter.battleIdle, 0, (int)(TILE_SIZE*10.5) - rightFighter.battleIdle.xOffset, TILE_SIZE*9 - rightFighter.battleIdle.yOffset);
        }
        else if (phase.equals("pause1"))
        {
            rightCard.show(rightCardPos, TILE_SIZE*15-88);
            leftCard.show(rightCardPos-120, TILE_SIZE*15-88);
            if (pauseTime > 0)
                pauseTime--;
            else
                phase = "approach";

            sprite(leftFighter.battleIdle, 0, (int)(TILE_SIZE*4.5) - leftFighter.battleIdle.xOffset, TILE_SIZE*9 - leftFighter.battleIdle.yOffset);
            sprite(rightFighter.battleIdle, 0, (int)(TILE_SIZE*10.5) - rightFighter.battleIdle.xOffset, TILE_SIZE*9 - rightFighter.battleIdle.yOffset);
        }
        else if (phase.equals("approach"))
        {
            if (attackerPos > (int)(-1.5*TILE_SIZE))
            {
                attackerPos -= MOVMENT_SPEED;
            }
            else
            {
                attackerPos = (int)(-1.5*TILE_SIZE);
                phase = "attack";
                pauseTime = 0;
                soundHandler.hit();
            }

            if (attacker == 1)
            {
                sprite(leftFighter.battleIdle, 0, (int)(TILE_SIZE*4.5) - leftFighter.battleIdle.xOffset, TILE_SIZE*9 - leftFighter.battleIdle.yOffset);
                int f = 0;
                int h = 0;
                if (rightFighter.attackStyle.equals("walk"))
                {
                    f = (systemClock()/4) % rightFighter.battleWalk.animLength();
                    h = 0;
                }
                else if (rightFighter.attackStyle.equals("jump"))
                {
                    float p = (TILE_SIZE*3.5 - attackerPos) / (4.5*TILE_SIZE);
                    f = min((int)(rightFighter.battleWalk.animLength()*p), rightFighter.battleWalk.animLength()-1);
                    h = (int)(192*p*(p-1.1));
                }

                sprite(rightFighter.battleWalk, f, (int)(TILE_SIZE*7.5) + attackerPos - rightFighter.battleWalk.xOffset, TILE_SIZE*9 - rightFighter.battleWalk.yOffset + h);
            }
            else if (attacker == -1)
            {
                sprite(rightFighter.battleIdle, 0, (int)(TILE_SIZE*10.5) - rightFighter.battleIdle.xOffset, TILE_SIZE*9 - rightFighter.battleIdle.yOffset);
                int f = 0;
                int h = 0;
                if (leftFighter.attackStyle.equals("walk"))
                {
                    f = (systemClock()/4) % leftFighter.battleWalk.animLength();
                    h = 0;
                }
                else if (leftFighter.attackStyle.equals("jump"))
                {
                    float p = (TILE_SIZE*3.5 - attackerPos) / (4.5*TILE_SIZE);
                    f = min((int)(leftFighter.battleWalk.animLength()*p), leftFighter.battleWalk.animLength()-1);
                    h = (int)(192*p*(p-1.1));
                }

                sprite(leftFighter.battleWalk, f, (int)(TILE_SIZE*7.5) - attackerPos - leftFighter.battleWalk.xOffset, TILE_SIZE*9 - leftFighter.battleWalk.yOffset + h);
            }


            rightCard.show(rightCardPos, TILE_SIZE*15-88);
            leftCard.show(rightCardPos-120, TILE_SIZE*15-88);
            image(fightmessageBg, TILE_SIZE, TILE_SIZE*9);
            for (int k = 0; k < attackMsg.length(); k++)
            {
                if (attackMsg.charAt(k) != ' ')
                {
                    letter(attackMsg.charAt(k), (int)(TILE_SIZE*1.5) + k*TILE_SIZE/2, TILE_SIZE*10, 
                        TILE_SIZE/2, TILE_SIZE/2);
                }
            }
        }
        else if (phase.equals("attack"))
        {
            pauseTime++;

            if (attacker == 1)
            {
                sprite(leftFighter.battleIdle, 0, (int)(TILE_SIZE*4.5) - leftFighter.battleIdle.xOffset, TILE_SIZE*9 - leftFighter.battleIdle.yOffset);
                sprite(rightFighter.battleAttack, min(pauseTime/8, rightFighter.battleAttack.animLength()-1), (int)(TILE_SIZE*7.5) + attackerPos - rightFighter.battleAttack.xOffset, TILE_SIZE*9 - rightFighter.battleAttack.yOffset);
            }
            else if (attacker == -1)
            {
                sprite(rightFighter.battleIdle, 0, (int)(TILE_SIZE*10.5) - rightFighter.battleIdle.xOffset, TILE_SIZE*9 - rightFighter.battleIdle.yOffset);
                sprite(leftFighter.battleAttack, min(pauseTime/8, leftFighter.battleAttack.animLength()-1), (int)(TILE_SIZE*7.5) - attackerPos - leftFighter.battleAttack.xOffset, TILE_SIZE*9 - leftFighter.battleAttack.yOffset);
            }

            if (dealt < damage)
            {
                dealt++;
                if (attacker == 1)
                    leftCard.curHealth--;
                else if (attacker == -1)
                    rightCard.curHealth--;
            }
            else
            {
                phase = "pause2";
                pauseTime = SECOND_PAUSE;
            }

            rightCard.show(rightCardPos, TILE_SIZE*15-88);
            leftCard.show(rightCardPos-120, TILE_SIZE*15-88);
            image(fightmessageBg, TILE_SIZE, TILE_SIZE*9);
            for (int k = 0; k < damageMsg.length(); k++)
            {
                if (damageMsg.charAt(k) != ' ')
                {
                    letter(damageMsg.charAt(k), (int)(TILE_SIZE*1.5) + k*TILE_SIZE/2, TILE_SIZE*10, 
                        TILE_SIZE/2, TILE_SIZE/2);
                }
            }
        }
        else if (phase.equals("pause2"))
        {
            if (pauseTime > 0)
                pauseTime--;
            else
            {
                phase = "end";
                leftFighter.hp = leftCard.curHealth;
                rightFighter.hp = rightCard.curHealth;
            }

            if (attacker == 1)
            {
                sprite(leftFighter.battleIdle, 0, (int)(TILE_SIZE*4.5) - leftFighter.battleIdle.xOffset, TILE_SIZE*9 - leftFighter.battleIdle.yOffset);
                sprite(rightFighter.battleAttack, rightFighter.battleAttack.animLength()-1, (int)(TILE_SIZE*7.5) + attackerPos - rightFighter.battleAttack.xOffset, TILE_SIZE*9 - rightFighter.battleAttack.yOffset);
            }
            else if (attacker == -1)
            {
                sprite(rightFighter.battleIdle, 0, (int)(TILE_SIZE*10.5) - rightFighter.battleIdle.xOffset, TILE_SIZE*9 - rightFighter.battleIdle.yOffset);
                sprite(leftFighter.battleAttack, leftFighter.battleAttack.animLength()-1, (int)(TILE_SIZE*7.5) - attackerPos - leftFighter.battleAttack.xOffset, TILE_SIZE*9 - leftFighter.battleAttack.yOffset);
            }

            rightCard.show(rightCardPos, TILE_SIZE*15-88);
            leftCard.show(rightCardPos-120, TILE_SIZE*15-88);
            image(fightmessageBg, TILE_SIZE, TILE_SIZE*9);
            for (int k = 0; k < damageMsg.length(); k++)
            {
                if (damageMsg.charAt(k) != ' ')
                {
                    letter(damageMsg.charAt(k), (int)(TILE_SIZE*1.5) + k*TILE_SIZE/2, TILE_SIZE*10, 
                        TILE_SIZE/2, TILE_SIZE/2);
                }
            }
        }
    }

    public boolean isDone()
    {
        return phase.equals("end");
    }
}