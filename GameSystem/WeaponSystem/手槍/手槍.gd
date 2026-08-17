@tool
extends WeaponBase




const SPEED := 750.0

func fire():
	_bullet_manager.create(
		BulletManager.TYPE.NORMAL_BULLET,
		_get_fire_pos(),
		SPEED * _get_fire_angle(),
		team
		)
	
