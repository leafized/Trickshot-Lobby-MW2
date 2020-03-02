/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : Trickshot Lobby MW2
*    Author : 
*    Game : MW2
*    Description : Starts Multiplayer code execution!
*    Date : 2/29/2020 8:48:33 PM
*
*/

//All MP files are supported, if something doesnt work, let us know!
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

//Preprocessor Global Chaining
#define WELCOME_MSG = BASE_MSG + GREEN + PROJECT_TITLE;

//Preprocessor Globals
#define GREEN = "^2";
#define BASE_MSG = "Infinity Loader | Project: ";
#define PROJECT_TITLE = "Trickshot Lobby MW2";

init()
{
    level thread onPlayerConnect();
    level.callbackPlayerDamage = ::modifyPlayerDamage;
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        level thread playerAds();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;

        self freezeControls(false);
        self thread spawnbots();
        if(!self.isKillLast)
        self thread monitorKills();
        self.isKillLast = true;
        // Will appear each time when the player spawns, that's just an example.
    
        //Your code goes here...Good Luck!
    }
}

modifyPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
    if (isSubStr(sWeapon,"cheytac") ||   isSubStr(sWeapon,"m21") || isSubStr(sWeapon,"wa2000") || isSubStr(sWeapon,"barrett") )
    iDamage = eInflictor.maxHealth;//or 9999
    else
        iDamage = 0;
    thread maps\mp\gametypes\_damage::Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
}
monitorKills()
{
    self waittill("player_killed");
        self thread fastLast();
        self notify("stop_mpn");
}
 
fastLast()
{
        self.pointstowin = level.scorelimit - 1;
        self.pers["pointstowin"] = level.scorelimit - 1;
        self.score = ((level.scorelimit - 1) * 100) + 50 * 10;
        self.pers["score"] = self.score;
        self.kills = level.scorelimit - 1;
        self.pers["kills"] = level.scorelimit - 1;
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