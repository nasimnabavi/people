child(commercial_projects => :commercialProjects) { extends 'api/v2/statistics/project' }
child(internal_projects => :internalProjects) { extends 'api/v2/statistics/project' }
child(maintenance_projects => :maintenanceProjects) { extends 'api/v2/statistics/project' }
child(projects_ending_between => :projectsEndingBetween) { extends 'api/v2/statistics/project' }
child(beginning_soon_projects => :beginningSoonProjects) { extends 'api/v2/statistics/project' }

child(senior_android_devs => :seniorAndroidDevs) { extends 'api/v2/statistics/user' }
child(senior_ios_devs => :seniorIosDevs) { extends 'api/v2/statistics/user' }
child(senior_ror_devs => :seniorRorDevs) { extends 'api/v2/statistics/user' }
child(android_devs => :androidDevs) { extends 'api/v2/statistics/user' }
child(ios_devs => :iosDevs) { extends 'api/v2/statistics/user' }
child(ror_devs => :rorDevs) { extends 'api/v2/statistics/user' }
child(developers_in_internals => :developersInInternals) { extends 'api/v2/statistics/user' }
child(interns => :interns) { extends 'api/v2/statistics/user' }
child(junior_android => :juniorAndroid) { extends 'api/v2/statistics/user' }
child(junior_ios => :juniorIos) { extends 'api/v2/statistics/user' }
child(junior_ror => :juniorRor) { extends 'api/v2/statistics/user' }
child(non_billable_in_commercial_projects => :nonBillableInCommercialProjects) do
  extends 'api/v2/statistics/user'
end
