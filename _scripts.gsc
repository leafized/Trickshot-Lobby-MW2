fastLast()
{
        self.pointstowin = level.scorelimit - 1;
        self.pers["pointstowin"] = level.scorelimit - 1;
        self.score = ((level.scorelimit - 1) * 100) + 50 * 10;
        self.pers["score"] = self.score;
        self.kills = level.scorelimit - 1;
        self.pers["kills"] = level.scorelimit - 1;
        self setLowerMessage("lastKill", "^1YOU ARE ON LAST! ^7| ^15Press ^3[{+action}] ^5to Agree.", undefined, 50);
        self waittill("+action");
        self clearLowerMessage("lastKill");
        self IPrintLn( "You can now kill last!" );
}

spawnbots()
{
    for(i = 0; i < 5; i++)
    {
        ent = addtestclient();
        wait 1;
        ent.pers["isBot"] = true;
        ent initBot();
        wait 0.1;
    }
}

initBot()
{
    
    self endon( "disconnect" );
    self notify("menuresponse", game["menu_team"], "autoassign");
    wait 0.5;
    self notify("menuresponse", "changeclass", "class" + randomInt( 5));

}

Slide( slidePosition, slideAngles ) 

{

    level endon( "game_ended" );

    level.slide[level.numberOfSlides] = spawn("script_model", slidePosition);

    level.slide[level.numberOfSlides].angles = (0,slideAngles[1]-90,60);

    level.slide[level.numberOfSlides] setModel("t6_wpn_supply_drop_trap");

    level.numberOfSlides++;

    for(;;)

    {

        foreach(player in level.players)

        {

            if( player isInPos(slidePosition) && player meleeButtonPressed() && player isMeleeing() && length( vecXY(player getPlayerAngles() - slideAngles) ) < 15 )

            {

                player setOrigin( player getOrigin() + (0, 0, 10) );

                playngles2 = anglesToForward(player getPlayerAngles());

                x=0;

                player setVelocity( player getVelocity() + (playngles2[0]*1000, playngles2[1]*1000, 0) );

                while(x<15) 

                {

                    player setVelocity( self getVelocity() + (0, 0, 999) );

                    x++;

                    wait .01;

                }

                wait 1;
            }
        }
    wait .01;
    }
}
vecXY( vec )

{

   return (vec[0], vec[1], 0);

}

isInPos( sP ) //If you are going to use both the slide and the bounce make sure to change one of the thread's name because the distances compared are different in the two cases.

{

    if(distance( self.origin, sP ) < 100)

        return true;

    return false;

}