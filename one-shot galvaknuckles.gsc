#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm;
#include scripts\zm\replaced\infdmggalv;
init()
{
	replaceFunc(maps\mp\zombies\_zm::actor_damage_override, scripts\zm\replaced\infdmggalv::actor_damage_override);
	setdvar("player_meleeRange", 64);
}