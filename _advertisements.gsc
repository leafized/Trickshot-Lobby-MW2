playerAdvs()
{
    self endon("death");
    level.msgs = ["Welcome to ^5Leafized's ^7Trickshot Lobby","^1Thank you for playing","Prone / Crouch + [{+melee}] + [{+smoke}] to Save / Load Location.","Tweet ^5@oLeafized^7 for suggestions","^2Snipers Only!","Download at ^4http://infinityloader.com"]; 
    for(;;) 
    {
        self iprintln(level.msgs[randomInt(level.msgs.size)]);
        wait 12;
    }
}
vector_scale(vec, scale)
{
   return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
