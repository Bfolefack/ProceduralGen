String[] MonsterTypes = { "Monstrosity","Plant","Aberration","Beast","Celestial", "Dragon","Construct","Elemental ","Fey", "Fiend","Object","Humanoid","Humanoid","Modern Animal","Modern Animal","Ancient Animal","Ooze","Insect","Undead" };
String[] Elements = { "Plant(Acid)","Ice","Fire","Earth","Lightning","Death","Divine","Thunder","Plant(Poison)","Air","Water","Wild Magic","Dual-Element" };
String[] RandomAspects = { "Keen Smell","Keen Sight","Keen Hearing","Tremorsense","Truesight","Prophetic","Camouflage","Dazzling(+Cha)","Disgusting(-Cha)","Captain","Shapechanging","Lycanthropic","Chimera(Multiple bases)","Strong","Sneaky","Spellcaster","Skeleton","Horrifying(Fear)","Armored","Intelligent","Elemental Body","Formless","Teleporting","Luminescent","Invisible","Furry","Scaled","Regenerating","Vital(2x HP)","Bloodlust","Multiplying","Exploding","Burrowing","Mind Warping","Flying","Climbing","Incorporeal","Hovering","Planeswalker","Taunting","Taunting","Hardening","Gravitational","Extra Limbs(Arms)","Extra Limbs(Head)","Extra Limbs(Other)","Armored","Tailed","Slimy/Sticky","Unstable" };
String[] Attacks = { "Weapon(Blade)","Weapon(Blunt)","Weapon(Stabby)","Claws","Horns","Bite(Beak)","Bite(Teeth)","Slashing","Slam","Swallow","Spear","Tail Attack","Charming Attack","Charge","Charge-up Attack","Kick","Tendril/Tentacl/Pseudopod","Elemental Attack/Breath Weapon","Healing","Ranged","Constrict","Life Drain" };
String[] Sizes = { "Tiny","Small","Medium","Large","Huge","Gargantuan","Planetary","Size-Shifting" };
Generator g;
void setup() {
 surface.setVisible( false );
 g = new Generator(1, 5, 3, true);
 g.generateMonster();
 g.generateMonster();
 g.generateMonster();
 g.generateMonster();
 g.generateMonster();
}
