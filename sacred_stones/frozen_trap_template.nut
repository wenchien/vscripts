=
function PreSpawnInstance( entityClass, entityName )
{
    local keyvalues = {};
	return keyvalues
}

function PostSpawn( entities )
{
	foreach( targetname, handle in entities )
	{
		templated_entities.push(handle);
	}
}

