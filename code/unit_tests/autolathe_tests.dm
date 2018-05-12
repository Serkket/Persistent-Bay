/*
	Unit tests for AUTOLATHE recipes
*/
/datum/unit_test/autolathe_recipe_test
	name = "AUTOLATHE: recipe test"

/datum/unit_test/autolathe_recipe_test/start_test()
	var/bad_tests = 0

	for(var/datum/autolathe/recipe/R in autolathe_recipes)
		var/failures = 0

		if(!ispath(R.path))
			failures++
			log_bad("[R.name] - does not have a path.")

		if(!R.category)
			failures++
			log_bad("[R.name] - does not have a category.")

		var/obj/item/stack/I = new R.path
		if(istype(I) && !R.is_stack)
			log_debug("[R.name] - is a recipe for a stack-type item, but is not defined as a stack.")
		qdel(I)

		if(failures > 0)
			bad_tests++

	if(bad_tests)
		fail("[bad_tests] autolathe recipe\s were missing either a path or category.")
	else
		pass("All autolathe recipes contained a correct path and category.")

	return 1

/datum/unit_test/autolathe_matter_test
	name = "AUTOLATHE: matter test"

/datum/unit_test/autolathe_matter_test/start_test()
	var/bad_tests = 0

	for(var/datum/autolathe/recipe/R in autolathe_recipes)
		var/failures = 0
		var/obj/item/I = new R.path
		if(I.matter)
			if(!R.resources)
				failures++
				log_bad("[R.name] - recipe does not have a resource requirement, but item contains matter.")
			else
				for(var/material in I.matter)
					if(R.resources[material] != I.matter[material] * EXTRA_COST_FACTOR)
						failures++
						log_bad("[R.name] - recipe [material] requirement is [R.resources[material]], but should be [I.matter[material] * EXTRA_COST_FACTOR].")
		else if(R.resources)
			log_debug("[R.name] - recipe requires resources, but item does not contain matter.")

		qdel(I)

		if(failures > 0)
			bad_tests++

	if(bad_tests)
		fail("[bad_tests] autolathe recipe\s had material costs inconsistent with item matter.")
	else
		pass("All autolathe recipes had material costs consistent with item matter.")

	return 1

/datum/unit_test/autolathe_control_test
	name = "AUTOLATHE: control test"

/datum/unit_test/autolathe_control_test/start_test()
	var/bad_tests = 0

	var/datum/autolathe/recipe/DR = new /datum/autolathe/recipe

	if(ispath(DR.path))
		bad_tests++
		log_bad("TEST RECIPE - initializes with a path")
	if(DR.category)
		bad_tests++
		log_bad("TEST RECIPE - initializes with a category.")
	if(DR.is_stack)
		bad_tests++
		log_bad("TEST RECIPE - is a stack.")
	if(DR.resources)
		bad_tests++
		log_bad("TEST RECIPE - has resource requirement.")

	if(bad_tests)
		fail("Autolathe test recipe failed [bad_tests] initialization tests.")
	else
		pass("Autolathe test recipe passed all initialization tests.")

	return 1