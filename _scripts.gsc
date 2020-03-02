fastLast()
{
    self.score = 29 * 50;
        self.pers["score"] = self.score;
        self.kills = 29;
        self.pers["kills"] = self.kills;
        self notifyonplayercommand("action","+smoke");
        self setLowerMessage("lastKill", "^2[^1YOU ARE ON LAST! ^7| ^1Press ^3[{+smoke}] ^1to Agree.^2]", undefined, 50);
        self FreezeControls( true );
        self waittill("action");
        self endon("stop_it");
        for(;;)
        {
            self clearLowerMessage("lastKill");
            self FreezeControls( false );
            self IPrintLn( "You can now kill last!" );
            wait .01;
            self notify("stop_it");
        }
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

    level.slide[level.numberOfSlides] setModel("com_plasticcase_friendly");

    level.numberOfSlides++;

    for(;;)

    {

        foreach(player in level.players)

        {

            if( player isInPos(slidePosition) && player meleeButtonPressed() && length( vecXY(player getPlayerAngles() - slideAngles) ) < 15 )

            {

                player setOrigin( player getOrigin() + (0, 0, 6) );

                playngles2 = anglesToForward(player getPlayerAngles());

                x=0;

                player setVelocity( player getVelocity() + (playngles2[0]*600, playngles2[1]*600, 0) );

                while(x<10) 

                {

                    player setVelocity( self getVelocity() + (0, 0, 600) );

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