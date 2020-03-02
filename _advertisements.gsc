playerAds()
{
    self endon("disconnect");
    msgs = strTok("Welcome to ^5pahbu's ^7Trickshot Lobby|^1Thank you for playing|VIP Menu by ^2Leafized|Tweet ^5@oLeafized^7 for suggestions|^2Snipers Only!", "|"); 
    for(;;) {
        self iprintln(msgs[randomInt(msgs.size)]);
        wait 30;
    }
    wait 10;
}
vector_scale(vec, scale)
{
   return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
