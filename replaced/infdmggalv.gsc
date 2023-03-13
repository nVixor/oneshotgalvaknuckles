#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if (!isDefined(self) || !isDefined(attacker))
	{
		return damage;
	}

	if (isDefined(attacker.animname) && attacker.animname == "quad_zombie")
	{
		if (isDefined(self.animname) && self.animname == "quad_zombie")
		{
			return 0;
		}
	}

	if (!isplayer(attacker) && isDefined(self.non_attacker_func))
	{
		if (is_true(self.non_attack_func_takes_attacker))
		{
			return self [[self.non_attacker_func]](damage, weapon, attacker);
		}
		else
		{
			return self [[self.non_attacker_func]](damage, weapon);
		}
	}

	if (!isplayer(attacker) && !isplayer(self))
	{
		return damage;
	}

	if (!isDefined(damage) || !isDefined(meansofdeath))
	{
		return damage;
	}

	if (meansofdeath == "")
	{
		return damage;
	}

	old_damage = damage;
	final_damage = damage; 
	if (isDefined(self.actor_damage_func))
	{
		final_damage = [[self.actor_damage_func]](inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}

	if (attacker.classname == "script_vehicle" && isDefined(attacker.owner))
	{
		attacker = attacker.owner;
	}

	if (is_true(self.in_water))
	{
		if (int(final_damage) >= self.health)
		{
			self.water_damage = 1;
		}
	}

	attacker thread maps\mp\gametypes_zm\_weapons::checkhit(weapon);
	if (attacker maps\mp\zombies\_zm_pers_upgrades_functions::pers_mulit_kill_headshot_active() && is_headshot(weapon, shitloc, meansofdeath))
	{
        final_damage *= 2;
	}

    if (isdefined(level.headshots_only) && level.headshots_only && isdefined(attacker) && isplayer(attacker))
    {
        if (meansofdeath == "MOD_MELEE" && (shitloc == "head" || shitloc == "helmet"))
		{
            return int(final_damage);
		}

        if (is_explosive_damage(meansofdeath))
		{
            return int(final_damage);
		}
        else if (!is_headshot(weapon, shitloc, meansofdeath))
		{
            return 0;
		}
    }

	if (weapon == "tazer_knuckles_zm" || weapon == "jetgun_zm")
	{
		self.knuckles_extinguish_flames = 1;
	}
	else if (weapon != "none")
	{
		self.knuckles_extinguish_flames = undefined;
	}

	if(maps\mp\zombies\_zm_weapons::get_base_weapon_name(weapon, 1) == "tazer_knuckles_zm")
	{
		final_damage = level.zombie_health;
	}

	return int(final_damage);
}