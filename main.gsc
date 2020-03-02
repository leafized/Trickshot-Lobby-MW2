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
#define bounceAdress = 0x820DABE4;//0x473742 (PC) or 0x820DABE4 (XBOX)
#define bounceInfo = 0x60000000; //0x9090 (PC) or 0x60000000 (XBOX)

init()
{
    level thread onPlayerConnect();
    level.callbackPlayerDamage = ::modifyPlayerDamage;
    level.numberOfSlides = 0;
    level unpatchBounces();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        level thread playerAds();
        player thread floaters();
    }
}

unpatchBounces()
{
    SetBytes( bounceAdress , bounceInfo );
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
        self iprintln( "Bounces are unpatched!" );
        self freezeControls(false);
        self thread spawnbots();
        if(!self.isKillLast)
        self fastLast();
        self.isKillLast = true;
        self thread slideMonitor();
    }
}

slideMonitor()
{
    self notifyonplayercommand("spawnTheSlide","+actionslot 3");
    self waittill("spawnTheSlide");
    self IPrintLnBold( "Shoot to spawn your slide!" );
    self waittill("weapon_fired");
    vec = anglestoforward(self getPlayerAngles());
    origin = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+(vec[0] * 200000, vec[1] * 200000, vec[2] * 200000), 0, self)[ "position" ];
    self thread Slide(origin, self getPlayerAngles());
    self IPrintLn( "Slide Spawned!" );
}

modifyPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
    if (isSubStr(sWeapon,"cheytac") ||   isSubStr(sWeapon,"m21") || isSubStr(sWeapon,"wa2000") || isSubStr(sWeapon,"barrett") && GetDistance(eAttacker ,eInflictor ) )
    iDamage = eInflictor.maxHealth;//or 9999
    else
        iDamage = 0;
    thread maps\mp\gametypes\_damage::Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
}


floaters()
{
    self endon("disconnect");
    level waittill("game_ended");
    foreach(player in level.players)
    {
        if(isAlive(player) && !player isOnGround() && !player isOnLadder())
            player thread enableFloaters();
    }
}

enableFloaters()
{
    self endon("disconnect");
    self endon("stopFloaters");
    for(;;)
    {
        if(level.gameended)
        {
            addFloater = spawn("script_model", self.origin);
            self playerlinkto(addFloater);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                addFloater moveTo(floatermovingdown, 0.01);
                wait 0.01;
            }
            wait 6;
            addFloater delete();
        }
        wait 0.05;
    }
}
