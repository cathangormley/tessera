extends Resource
class_name JobDB

enum CoreJob { WARRIOR, THIEF, MAGE, CLERIC }

## Mapping from enum of core jobs to Job resources
static var core_jobs: Dictionary[CoreJob, Job] = {
	CoreJob.WARRIOR: preload("res://data/jobs/jobs/warrior.tres"),
	CoreJob.THIEF: preload("res://data/jobs/jobs/thief.tres"),
	CoreJob.MAGE: preload("res://data/jobs/jobs/mage.tres"),
	CoreJob.CLERIC: preload("res://data/jobs/jobs/cleric.tres"),
}
